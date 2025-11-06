import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/ui_helpers.dart';
import '../../../models/payment_record.dart';
import 'payment_history_viewmodel.dart';

class PaymentHistoryView extends StackedView<PaymentHistoryViewModel> {
  const PaymentHistoryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Payment History'),
        backgroundColor: const Color(0xFF1A1F3A),
        elevation: 0,
        actions: [
          if (viewModel.hasPayments)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: viewModel.clearHistory,
              tooltip: 'Clear History',
            ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : viewModel.hasPayments
              ? RefreshIndicator(
                  onRefresh: viewModel.loadPaymentRecords,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: viewModel.paymentRecords.length,
                    itemBuilder: (context, index) {
                      final record = viewModel.paymentRecords[index];
                      return _buildPaymentCard(context, viewModel, record);
                    },
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 80,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      verticalSpaceMedium,
                      Text(
                        'No payment history',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      verticalSpaceSmall,
                      Text(
                        'Your payment records will appear here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    PaymentHistoryViewModel viewModel,
    PaymentRecord record,
  ) {
    Color statusColor;
    IconData statusIcon;

    switch (record.status) {
      case PaymentStatus.success:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case PaymentStatus.failed:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case PaymentStatus.pending:
      case PaymentStatus.processing:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case PaymentStatus.cancelled:
        statusColor = Colors.grey;
        statusIcon = Icons.cancel;
        break;
    }

    return GestureDetector(
      onTap: () => viewModel.viewPaymentDetails(record),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                horizontalSpaceSmall,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.paymentRequest.ticketName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      verticalSpaceTiny,
                      Text(
                        record.statusText,
                        style: TextStyle(
                          fontSize: 13,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'KES ${record.paymentRequest.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            verticalSpaceSmall,
            const Divider(color: Colors.white24),
            verticalSpaceTiny,
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
                horizontalSpaceTiny,
                Text(
                  '${record.paymentRequest.firstName} ${record.paymentRequest.lastName}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
                horizontalSpaceTiny,
                Text(
                  _formatDate(record.createdAt),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  PaymentHistoryViewModel viewModelBuilder(BuildContext context) =>
      PaymentHistoryViewModel();

  @override
  void onViewModelReady(PaymentHistoryViewModel viewModel) {
    viewModel.loadPaymentRecords();
    super.onViewModelReady(viewModel);
  }
}

