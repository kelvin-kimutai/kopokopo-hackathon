import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k2_connect_flutter/k2_connect_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/payment_request.dart';
import '../models/payment_record.dart';

/// Comprehensive Kopo Kopo service that exhaustively uses all SDK features
class KopokopoService {
  static KopokopoService? _instance;
  static KopokopoService get instance => _instance ??= KopokopoService._();

  KopokopoService._();

  bool _isInitialized = false;
  String? _currentAccessToken;
  DateTime? _tokenExpiryTime;

  /// Initialize the K2 Connect SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await K2ConnectFlutter.initialize(
        baseUrl: AppConfig.k2BaseUrl,
        credentials: K2ConnectCredentials(
          clientId: AppConfig.k2ClientId,
          clientSecret: AppConfig.k2ClientSecret,
          apiKey: AppConfig.k2ApiKey,
        ),
        loggingEnabled: kDebugMode, // Enable logging in debug mode
      );
      _isInitialized = true;
      debugPrint('✅ Kopo Kopo SDK initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Kopo Kopo SDK: $e');
      rethrow;
    }
  }

  /// Get TokenService instance from SDK
  TokenService get _tokenService => K2ConnectFlutter.tokenService();

  /// Get StkService instance from SDK
  dynamic get _stkService => K2ConnectFlutter.stkService();

  /// Request a new access token
  /// This demonstrates the Token Service feature
  Future<String> requestAccessToken({bool forceRefresh = false}) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Check if we have a valid cached token
    if (!forceRefresh &&
        _currentAccessToken != null &&
        _tokenExpiryTime != null) {
      if (DateTime.now().isBefore(_tokenExpiryTime!)) {
        debugPrint('✅ Using cached access token');
        return _currentAccessToken!;
      }
    }

    try {
      debugPrint('🔄 Requesting new access token...');
      final TokenResponse tokenResponse =
          await _tokenService.requestAccessToken();

      _currentAccessToken = tokenResponse.accessToken;

      // Calculate expiry time (subtract 5 minutes for safety buffer)
      final expiresInSeconds = tokenResponse.expiresIn;
      _tokenExpiryTime = DateTime.now().add(
        Duration(seconds: expiresInSeconds - 300),
      );

      // Cache token in shared preferences
      await _cacheToken(tokenResponse);

      debugPrint('✅ Access token obtained successfully');
      debugPrint('Token Type: ${tokenResponse.tokenType}');
      debugPrint('Expires In: ${tokenResponse.expiresIn} seconds');
      debugPrint('Created At: ${tokenResponse.createdAt}');

      return _currentAccessToken!;
    } catch (e) {
      debugPrint('❌ Failed to request access token: $e');
      rethrow;
    }
  }

  /// Revoke the current access token
  /// This demonstrates the Token Revocation feature
  Future<void> revokeAccessToken() async {
    if (_currentAccessToken == null) {
      debugPrint('⚠️ No token to revoke');
      return;
    }

    try {
      debugPrint('🔄 Revoking access token...');
      await _tokenService.revokeAccessToken(_currentAccessToken!);

      _currentAccessToken = null;
      _tokenExpiryTime = null;

      // Clear cached token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('k2_access_token');
      await prefs.remove('k2_token_expiry');

      debugPrint('✅ Access token revoked successfully');
    } catch (e) {
      debugPrint('❌ Failed to revoke access token: $e');
      rethrow;
    }
  }

  /// Get a valid access token (requests new one if needed)
  Future<String> getValidAccessToken() async {
    return await requestAccessToken();
  }

  /// Initiate STK Push payment WITH UI (Bottom Sheet)
  /// This demonstrates the STK Push with UI feature
  Future<void> initiatePaymentWithUI({
    required BuildContext context,
    required PaymentRequest paymentRequest,
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      final accessToken = await getValidAccessToken();

      debugPrint('🔄 Initiating STK Push with UI...');
      debugPrint('Amount: KES ${paymentRequest.amount}');
      debugPrint(
          'Customer: ${paymentRequest.firstName} ${paymentRequest.lastName}');

      // Generate a unique payment ID for tracking
      final paymentId = 'ui_${DateTime.now().millisecondsSinceEpoch}';
      final initiationTime = DateTime.now();

      // Build metadata with a maximum of 5 key-value pairs
      // Start with the essential fixed keys
      final Map<String, dynamic> metadata = {
        'ticketId': paymentRequest.ticketId,
        'ticketName': paymentRequest.ticketName,
        'customerEmail': paymentRequest.email,
        'customerName':
            '${paymentRequest.firstName} ${paymentRequest.lastName}',
        'eventName': AppConfig.conferenceTitle,
      };

      // Add custom metadata only if there's room (max 5 total)
      // Since we already have 5 keys, we won't add custom metadata
      // If you need custom metadata, you can replace one of the fixed keys
      if (paymentRequest.metadata.isNotEmpty && metadata.length < 5) {
        final remainingSlots = 5 - metadata.length;
        final customEntries =
            paymentRequest.metadata.entries.take(remainingSlots);
        for (final entry in customEntries) {
          metadata[entry.key] = entry.value;
        }
      }

      final stkPushRequest = StkPushRequest(
        companyName: AppConfig.conferenceTitle,
        tillNumber: AppConfig.k2TillNumber,
        amount: Amount(
          currency: 'KES',
          value: paymentRequest.amount.toStringAsFixed(2),
        ),
        callbackUrl: AppConfig.k2CallbackUrl,
        metadata: metadata,
        onSuccess: () async {
          debugPrint('✅ Payment with UI successful');
          
          // Create and store payment record
          final paymentRecord = PaymentRecord(
            id: paymentId,
            locationUrl: 'N/A', // UI method doesn't expose location URL
            paymentRequest: paymentRequest,
            status: PaymentStatus.success,
            createdAt: initiationTime,
            transactionReference: 'UI-${DateTime.now().millisecondsSinceEpoch}',
          );
          
          await _storePaymentRecord(paymentRecord);
          debugPrint('💾 Payment record saved to history');
          
          onSuccess();
        },
        onError: (error) async {
          debugPrint('❌ Payment with UI failed: $error');
          
          // Store failed payment record for history
          final paymentRecord = PaymentRecord(
            id: paymentId,
            locationUrl: 'N/A',
            paymentRequest: paymentRequest,
            status: PaymentStatus.failed,
            createdAt: initiationTime,
            errorMessage: error,
          );
          
          await _storePaymentRecord(paymentRecord);
          debugPrint('💾 Failed payment record saved to history');
          
          onError(error);
        },
        accessToken: accessToken,
      );

      // Check if context is still mounted before using it
      if (context.mounted) {
        await _stkService.requestPaymentBottomSheet(
          context,
          stkPushRequest: stkPushRequest,
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to initiate payment with UI: $e');
      onError(e.toString());
    }
  }

  /// Initiate STK Push payment WITHOUT UI (Direct API call)
  /// This demonstrates the STK Push without UI feature
  Future<PaymentRecord> initiatePaymentWithoutUI({
    required PaymentRequest paymentRequest,
  }) async {
    try {
      final accessToken = await getValidAccessToken();

      debugPrint('🔄 Initiating STK Push without UI...');
      debugPrint('Phone: ${paymentRequest.phoneNumber}');
      debugPrint('Amount: KES ${paymentRequest.amount}');

      // Build metadata with a maximum of 5 key-value pairs
      // Start with the essential fixed keys
      final Map<String, dynamic> metadata = {
        'ticketId': paymentRequest.ticketId,
        'ticketName': paymentRequest.ticketName,
        'customerEmail': paymentRequest.email,
        'customerName':
            '${paymentRequest.firstName} ${paymentRequest.lastName}',
        'eventName': AppConfig.conferenceTitle,
      };

      // Add custom metadata only if there's room (max 5 total)
      // Since we already have 5 keys, we won't add custom metadata
      // If you need custom metadata, you can replace one of the fixed keys
      if (paymentRequest.metadata.isNotEmpty && metadata.length < 5) {
        final remainingSlots = 5 - metadata.length;
        final customEntries =
            paymentRequest.metadata.entries.take(remainingSlots);
        for (final entry in customEntries) {
          metadata[entry.key] = entry.value;
        }
      }

      final stkPushRequest = StkPushRequest(
        tillNumber: AppConfig.k2TillNumber,
        subscriber: Subscriber(
          phoneNumber: paymentRequest.phoneNumber,
          firstName: paymentRequest.firstName,
          lastName: paymentRequest.lastName,
          email: paymentRequest.email,
        ),
        amount: Amount(
          value: paymentRequest.amount.toStringAsFixed(2),
          currency: 'KES',
        ),
        callbackUrl: AppConfig.k2CallbackUrl,
        metadata: metadata,
        accessToken: accessToken,
      );

      final String locationUrl = await _stkService.requestPayment(
        stkPushRequest: stkPushRequest,
      );

      debugPrint('✅ STK Push initiated successfully');
      debugPrint('Location URL: $locationUrl');

      // Create payment record
      final paymentRecord = PaymentRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        locationUrl: locationUrl,
        paymentRequest: paymentRequest,
        status: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

      // Store payment record
      await _storePaymentRecord(paymentRecord);

      return paymentRecord;
    } catch (e) {
      debugPrint('❌ Failed to initiate payment without UI: $e');
      rethrow;
    }
  }

  /// Query the status of an STK Push request
  /// This demonstrates the Payment Status Query feature
  Future<StkPushRequestStatus> checkPaymentStatus({
    required String locationUrl,
  }) async {
    try {
      final accessToken = await getValidAccessToken();

      debugPrint('🔄 Checking payment status...');
      debugPrint('Location URL: $locationUrl');

      final StkPushRequestStatus status = await _stkService.requestStatus(
        uri: locationUrl,
        accessToken: accessToken,
      );

      debugPrint('✅ Payment status retrieved successfully');
      debugPrint('Request ID: ${status.id}');
      debugPrint('Type: ${status.type}');
      debugPrint('Status: ${status.attributes.status}');
      debugPrint('Initiation Time: ${status.attributes.initiationTime}');

      if (status.attributes.event != null) {
        debugPrint('Event Type: ${status.attributes.event!.type}');
        if (status.attributes.event!.errors != null) {
          debugPrint('Errors: ${status.attributes.event!.errors}');
        }
      }

      return status;
    } catch (e) {
      debugPrint('❌ Failed to check payment status: $e');
      rethrow;
    }
  }

  /// Update payment record status based on SDK response
  Future<PaymentRecord> updatePaymentRecordStatus({
    required PaymentRecord record,
    required StkPushRequestStatus status,
  }) async {
    PaymentStatus newStatus;
    String? errorMessage;
    String? transactionReference;

    // Map SDK status to our internal status
    switch (status.attributes.status.toLowerCase()) {
      case 'pending':
        newStatus = PaymentStatus.pending;
        break;
      case 'processing':
        newStatus = PaymentStatus.processing;
        break;
      case 'success':
      case 'successful':
        newStatus = PaymentStatus.success;
        if (status.attributes.event?.resource != null) {
          transactionReference = status.attributes.event!.resource.toString();
        }
        break;
      case 'failed':
        newStatus = PaymentStatus.failed;
        errorMessage = status.attributes.event?.errors;
        break;
      case 'cancelled':
        newStatus = PaymentStatus.cancelled;
        break;
      default:
        newStatus = PaymentStatus.pending;
    }

    final updatedRecord = record.copyWith(
      status: newStatus,
      errorMessage: errorMessage,
      transactionReference: transactionReference,
    );

    await _storePaymentRecord(updatedRecord);
    return updatedRecord;
  }

  /// Cache token in shared preferences
  Future<void> _cacheToken(TokenResponse tokenResponse) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('k2_access_token', tokenResponse.accessToken);
      await prefs.setString('k2_token_type', tokenResponse.tokenType);
      final expiryTime = DateTime.now().add(
        Duration(seconds: tokenResponse.expiresIn),
      );
      await prefs.setString('k2_token_expiry', expiryTime.toIso8601String());
    } catch (e) {
      debugPrint('⚠️ Failed to cache token: $e');
    }
  }

  /// Store payment record
  Future<void> _storePaymentRecord(PaymentRecord record) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getAllPaymentRecords();

      // Update or add record
      final index = records.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        records[index] = record;
      } else {
        records.add(record);
      }

      final jsonList = records.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList('payment_records', jsonList);
    } catch (e) {
      debugPrint('⚠️ Failed to store payment record: $e');
    }
  }

  /// Get all payment records
  Future<List<PaymentRecord>> getAllPaymentRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList('payment_records') ?? [];
      return jsonList.map((json) {
        return PaymentRecord.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('⚠️ Failed to get payment records: $e');
      return [];
    }
  }

  /// Get payment record by ID
  Future<PaymentRecord?> getPaymentRecordById(String id) async {
    final records = await getAllPaymentRecords();
    try {
      return records.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear all payment records
  Future<void> clearAllPaymentRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('payment_records');
      debugPrint('✅ All payment records cleared');
    } catch (e) {
      debugPrint('⚠️ Failed to clear payment records: $e');
    }
  }
}
