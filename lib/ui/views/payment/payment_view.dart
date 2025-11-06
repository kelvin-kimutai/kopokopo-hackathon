import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../../common/ui_helpers.dart';
import '../../../models/ticket_type.dart';
import 'payment_viewmodel.dart';

class PaymentView extends StackedView<PaymentViewModel> {
  final TicketType ticket;

  const PaymentView({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PaymentViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: const Color(0xFF1A1F3A),
        elevation: 0,
      ),
      body: viewModel.isBusy
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blueAccent),
                  SizedBox(height: 16),
                  Text(
                    'Processing payment...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ticket Summary
                  _buildTicketSummary(context, ticket),
                  verticalSpaceMedium,

                  // Payment Method Selection
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  verticalSpaceSmall,
                  _buildPaymentMethodSelector(viewModel),
                  verticalSpaceMedium,

                  // Customer Information Form
                  const Text(
                    'Your Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  verticalSpaceSmall,
                  _buildCustomerForm(viewModel),
                  verticalSpaceLarge,

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: viewModel.canProceed
                          ? () => viewModel.proceedToPayment(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment, size: 24),
                          horizontalSpaceSmall,
                          Text(
                            'Pay ${ticket.formattedPrice}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Center(
                    child: Text(
                      'Powered by Kopo Kopo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTicketSummary(BuildContext context, TicketType ticket) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.3),
            Colors.blueAccent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.confirmation_number, color: Colors.blueAccent),
              horizontalSpaceSmall,
              const Text(
                'Ticket Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          const Divider(color: Colors.white24),
          verticalSpaceSmall,
          _buildSummaryRow('Ticket Type', ticket.name),
          verticalSpaceTiny,
          _buildSummaryRow('Price', ticket.formattedPrice),
          verticalSpaceTiny,
          _buildSummaryRow('Event', 'FlutterConKE25 + DroidConKE'),
          verticalSpaceTiny,
          _buildSummaryRow('Date', '5th - 7th November 2025'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector(PaymentViewModel viewModel) {
    return Column(
      children: [
        _buildPaymentMethodCard(
          viewModel: viewModel,
          method: PaymentMethod.withUI,
          title: 'Quick Pay (Recommended)',
          description: 'Enter phone number in an interactive dialog',
          icon: Icons.phone_android,
        ),
        verticalSpaceSmall,
        _buildPaymentMethodCard(
          viewModel: viewModel,
          method: PaymentMethod.withoutUI,
          title: 'Direct Payment',
          description: 'Direct API call with status tracking',
          icon: Icons.api,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required PaymentViewModel viewModel,
    required PaymentMethod method,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = viewModel.selectedMethod == method;

    return GestureDetector(
      onTap: () => viewModel.selectPaymentMethod(method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withOpacity(0.2)
              : const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blueAccent),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  verticalSpaceTiny,
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blueAccent,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerForm(PaymentViewModel viewModel) {
    return Column(
      children: [
        _buildTextField(
          controller: viewModel.firstNameController,
          label: 'First Name',
          icon: Icons.person,
          onChanged: (_) => viewModel.rebuildUi(),
        ),
        verticalSpaceSmall,
        _buildTextField(
          controller: viewModel.lastNameController,
          label: 'Last Name',
          icon: Icons.person_outline,
          onChanged: (_) => viewModel.rebuildUi(),
        ),
        verticalSpaceSmall,
        _buildTextField(
          controller: viewModel.emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => viewModel.rebuildUi(),
        ),
        verticalSpaceSmall,
        _buildTextField(
          controller: viewModel.phoneController,
          label: 'Phone Number (e.g., 0712345678)',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          onChanged: (_) => viewModel.rebuildUi(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: const Color(0xFF1A1F3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  @override
  PaymentViewModel viewModelBuilder(BuildContext context) => PaymentViewModel();

  @override
  void onViewModelReady(PaymentViewModel viewModel) {
    viewModel.ticket = ticket;
    super.onViewModelReady(viewModel);
  }
}

