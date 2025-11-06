import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/ticket_type.dart';
import '../../../models/payment_request.dart';
import '../../../services/kopokopo_service.dart';

class PaymentViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _kopokopoService = KopokopoService.instance;

  late TicketType ticket;

  // Form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Payment method selection
  PaymentMethod _selectedMethod = PaymentMethod.withUI;
  PaymentMethod get selectedMethod => _selectedMethod;

  void selectPaymentMethod(PaymentMethod method) {
    _selectedMethod = method;
    rebuildUi();
  }

  bool get canProceed {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;
  }

  Future<void> proceedToPayment(BuildContext context) async {
    if (!canProceed) {
      await _dialogService.showDialog(
        title: 'Missing Information',
        description: 'Please fill in all fields to continue.',
      );
      return;
    }

    // Validate phone number
    final phone = _formatPhoneNumber(phoneController.text);
    if (phone.isEmpty) {
      await _dialogService.showDialog(
        title: 'Invalid Phone Number',
        description: 'Please enter a valid Kenyan phone number (e.g., 0712345678)',
      );
      return;
    }

    final paymentRequest = PaymentRequest(
      ticketId: ticket.id,
      ticketName: ticket.name,
      amount: ticket.price,
      phoneNumber: phone,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      metadata: {
        'paymentMethod': _selectedMethod.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    if (_selectedMethod == PaymentMethod.withUI) {
      await _processPaymentWithUI(context, paymentRequest);
    } else {
      await _processPaymentWithoutUI(paymentRequest);
    }
  }

  Future<void> _processPaymentWithUI(
    BuildContext context,
    PaymentRequest paymentRequest,
  ) async {
    setBusy(true);
    try {
      await _kopokopoService.initiatePaymentWithUI(
        context: context,
        paymentRequest: paymentRequest,
        onSuccess: () async {
          setBusy(false);
          await _showSuccessDialog();
        },
        onError: (error) async {
          setBusy(false);
          await _showErrorDialog(error);
        },
      );
    } catch (e) {
      setBusy(false);
      await _showErrorDialog(e.toString());
    }
  }

  Future<void> _processPaymentWithoutUI(PaymentRequest paymentRequest) async {
    setBusy(true);
    setError(null);

    try {
      final paymentRecord = await _kopokopoService.initiatePaymentWithoutUI(
        paymentRequest: paymentRequest,
      );

      setBusy(false);

      // Navigate to payment tracking screen
      await _navigationService.navigateToPaymentTrackingView(
        paymentRecord: paymentRecord,
      );
    } catch (e) {
      setBusy(false);
      setError(e.toString());
      await _showErrorDialog(e.toString());
    }
  }

  String _formatPhoneNumber(String phone) {
    // Remove all non-numeric characters
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Convert to international format
    if (cleaned.startsWith('0') && cleaned.length == 10) {
      return '254${cleaned.substring(1)}';
    } else if (cleaned.startsWith('254') && cleaned.length == 12) {
      return cleaned;
    } else if (cleaned.startsWith('+254')) {
      return cleaned.substring(1);
    }

    return ''; // Invalid format
  }

  Future<void> _showSuccessDialog() async {
    await _dialogService.showDialog(
      title: '🎉 Payment Initiated!',
      description:
          'Your payment request has been sent. Please check your phone to complete the M-Pesa transaction.',
    );
    _navigationService.back();
  }

  Future<void> _showErrorDialog(String error) async {
    await _dialogService.showDialog(
      title: '❌ Payment Failed',
      description: 'An error occurred: $error',
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

enum PaymentMethod {
  withUI,
  withoutUI,
}

