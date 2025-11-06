import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/ui_helpers.dart';
import '../../../models/payment_record.dart';
import 'payment_tracking_viewmodel.dart';

class PaymentTrackingView extends StackedView<PaymentTrackingViewModel> {
  final PaymentRecord paymentRecord;

  const PaymentTrackingView({Key? key, required this.paymentRecord})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PaymentTrackingViewModel viewModel,
    Widget? child,
  ) {
    return WillPopScope(
      onWillPop: () async {
        viewModel.goBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E27),
        appBar: AppBar(
          title: const Text('Payment Status'),
          backgroundColor: const Color(0xFF1A1F3A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: viewModel.goBack,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: viewModel.manualRefresh,
              tooltip: 'Refresh Status',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              verticalSpaceMedium,

              // Status Icon
              _buildStatusIcon(viewModel.paymentRecord.status),
              verticalSpaceMedium,

              // Status Message
              Text(
                viewModel.statusMessage,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpaceSmall,

              // Status Description
              Text(
                viewModel.statusDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpaceMedium,

              // Payment Details Card
              _buildPaymentDetailsCard(viewModel.paymentRecord),
              verticalSpaceMedium,

              // Status Timeline (if available)
              if (viewModel.latestStatus != null)
                _buildStatusTimeline(viewModel.latestStatus!),

              verticalSpaceMedium,

              // Action Buttons
              if (viewModel.paymentRecord.status == PaymentStatus.success ||
                  viewModel.paymentRecord.status == PaymentStatus.failed ||
                  viewModel.paymentRecord.status == PaymentStatus.cancelled)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: viewModel.goHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Loading indicator for pending/processing
              if (viewModel.paymentRecord.status == PaymentStatus.pending ||
                  viewModel.paymentRecord.status == PaymentStatus.processing)
                const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.blueAccent),
                    SizedBox(height: 16),
                    Text(
                      'Auto-checking status...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(PaymentStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case PaymentStatus.pending:
      case PaymentStatus.processing:
        icon = Icons.pending;
        color = Colors.orange;
        break;
      case PaymentStatus.success:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case PaymentStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      case PaymentStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.grey;
        break;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 3),
      ),
      child: Icon(icon, size: 60, color: color),
    );
  }

  Widget _buildPaymentDetailsCard(PaymentRecord record) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          verticalSpaceSmall,
          const Divider(color: Colors.white24),
          verticalSpaceSmall,
          _buildDetailRow('Ticket', record.paymentRequest.ticketName),
          _buildDetailRow(
            'Amount',
            'KES ${record.paymentRequest.amount.toStringAsFixed(2)}',
          ),
          _buildDetailRow('Customer', 
              '${record.paymentRequest.firstName} ${record.paymentRequest.lastName}'),
          _buildDetailRow('Phone', record.paymentRequest.phoneNumber),
          _buildDetailRow('Email', record.paymentRequest.email),
          _buildDetailRow(
            'Date',
            '${record.createdAt.day}/${record.createdAt.month}/${record.createdAt.year} ${record.createdAt.hour}:${record.createdAt.minute.toString().padLeft(2, '0')}',
          ),
          if (record.transactionReference != null) ...[
            verticalSpaceTiny,
            _buildDetailRow('Reference', record.transactionReference!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(dynamic status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          verticalSpaceSmall,
          const Divider(color: Colors.white24),
          verticalSpaceSmall,
          _buildDetailRow('Request ID', status.id ?? 'N/A'),
          _buildDetailRow('Type', status.type ?? 'N/A'),
          _buildDetailRow('Status', status.attributes?.status ?? 'N/A'),
          if (status.attributes?.initiationTime != null)
            _buildDetailRow('Initiated', status.attributes!.initiationTime!),
        ],
      ),
    );
  }

  @override
  PaymentTrackingViewModel viewModelBuilder(BuildContext context) =>
      PaymentTrackingViewModel();

  @override
  void onViewModelReady(PaymentTrackingViewModel viewModel) {
    viewModel.paymentRecord = paymentRecord;
    viewModel.startStatusChecking();
    super.onViewModelReady(viewModel);
  }
}

