import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/ticket_type.dart';

class ConferenceHomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  TicketType? _selectedTicket;
  TicketType? get selectedTicket => _selectedTicket;

  List<TicketType> get availableTickets => TicketType.availableTickets;

  void selectTicket(TicketType ticket) {
    _selectedTicket = ticket;
    rebuildUi();
  }

  bool get canProceedToPayment => _selectedTicket != null;

  Future<void> proceedToPayment() async {
    if (_selectedTicket == null) return;

    await _navigationService.navigateToPaymentView(
      ticket: _selectedTicket!,
    );
  }

  void viewPaymentHistory() {
    _navigationService.navigateToPaymentHistoryView();
  }
}

