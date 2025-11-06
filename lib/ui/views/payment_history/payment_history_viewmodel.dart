import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/payment_record.dart';
import '../../../services/kopokopo_service.dart';

class PaymentHistoryViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _kopokopoService = KopokopoService.instance;

  List<PaymentRecord> _paymentRecords = [];
  List<PaymentRecord> get paymentRecords => _paymentRecords;

  bool get hasPayments => _paymentRecords.isNotEmpty;

  Future<void> loadPaymentRecords() async {
    setBusy(true);
    try {
      _paymentRecords = await _kopokopoService.getAllPaymentRecords();
      // Sort by date (newest first)
      _paymentRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setBusy(false);
    } catch (e) {
      setBusy(false);
      setError(e.toString());
    }
  }

  Future<void> viewPaymentDetails(PaymentRecord record) async {
    await _navigationService.navigateToPaymentTrackingView(
      paymentRecord: record,
    );
    // Reload after returning
    await loadPaymentRecords();
  }

  Future<void> clearHistory() async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'Clear History',
      description: 'Are you sure you want to clear all payment history?',
      confirmationTitle: 'Clear',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed ?? false) {
      await _kopokopoService.clearAllPaymentRecords();
      await loadPaymentRecords();
    }
  }
}

