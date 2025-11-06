import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../models/payment_record.dart';
import '../../../services/kopokopo_service.dart';
import 'package:k2_connect_flutter/k2_connect_flutter.dart';

class PaymentTrackingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _kopokopoService = KopokopoService.instance;

  late PaymentRecord paymentRecord;
  Timer? _statusCheckTimer;
  int _checkCount = 0;
  static const int maxChecks = 60; // Check for up to 5 minutes (every 5 seconds)

  StkPushRequestStatus? _latestStatus;
  StkPushRequestStatus? get latestStatus => _latestStatus;

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  void startStatusChecking() {
    // Check immediately
    checkPaymentStatus();

    // Then check every 5 seconds
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (_checkCount >= maxChecks) {
          timer.cancel();
          _handleTimeout();
          return;
        }

        if (paymentRecord.status == PaymentStatus.success ||
            paymentRecord.status == PaymentStatus.failed ||
            paymentRecord.status == PaymentStatus.cancelled) {
          timer.cancel();
          return;
        }

        checkPaymentStatus();
        _checkCount++;
      },
    );
  }

  Future<void> checkPaymentStatus() async {
    try {
      debugPrint('🔄 Checking payment status (attempt ${_checkCount + 1})...');

      final status = await _kopokopoService.checkPaymentStatus(
        locationUrl: paymentRecord.locationUrl,
      );

      _latestStatus = status;

      // Update payment record
      paymentRecord = await _kopokopoService.updatePaymentRecordStatus(
        record: paymentRecord,
        status: status,
      );

      rebuildUi();

      // Log status details
      debugPrint('Status: ${status.attributes.status}');
      if (status.attributes.event != null) {
        debugPrint('Event Type: ${status.attributes.event!.type}');
        if (status.attributes.event!.errors != null) {
          debugPrint('Errors: ${status.attributes.event!.errors}');
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking payment status: $e');
      setError(e.toString());
    }
  }

  void _handleTimeout() {
    debugPrint('⏱️ Payment status check timeout');
    if (paymentRecord.status == PaymentStatus.pending ||
        paymentRecord.status == PaymentStatus.processing) {
      // Update to failed status
      paymentRecord = paymentRecord.copyWith(
        status: PaymentStatus.failed,
        errorMessage: 'Payment verification timeout. Please check your M-Pesa messages.',
      );
      rebuildUi();
    }
  }

  void manualRefresh() {
    _checkCount = 0;
    checkPaymentStatus();
  }

  void goBack() {
    _statusCheckTimer?.cancel();
    _navigationService.back();
  }

  void goHome() {
    _statusCheckTimer?.cancel();
    _navigationService.clearStackAndShow('/conference-home-view');
  }

  String get statusMessage {
    switch (paymentRecord.status) {
      case PaymentStatus.pending:
        return 'Waiting for M-Pesa prompt...';
      case PaymentStatus.processing:
        return 'Processing your payment...';
      case PaymentStatus.success:
        return 'Payment successful! 🎉';
      case PaymentStatus.failed:
        return 'Payment failed';
      case PaymentStatus.cancelled:
        return 'Payment cancelled';
    }
  }

  String get statusDescription {
    switch (paymentRecord.status) {
      case PaymentStatus.pending:
        return 'Please check your phone for the M-Pesa payment prompt and enter your PIN.';
      case PaymentStatus.processing:
        return 'Your payment is being verified. This may take a few moments.';
      case PaymentStatus.success:
        return 'Thank you! Your ticket for ${paymentRecord.paymentRequest.ticketName} has been confirmed. Check your email for details.';
      case PaymentStatus.failed:
        return paymentRecord.errorMessage ??
            'The payment could not be completed. Please try again.';
      case PaymentStatus.cancelled:
        return 'The payment was cancelled. You can try again if you wish.';
    }
  }
}

