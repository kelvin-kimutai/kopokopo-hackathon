import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/ui_helpers.dart';
import '../../../models/ticket_type.dart';
import '../../../config/app_config.dart';
import 'conference_home_viewmodel.dart';

class ConferenceHomeView extends StackedView<ConferenceHomeViewModel> {
  const ConferenceHomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ConferenceHomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 360.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF0A0E27),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  AppConfig.conferenceTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF1E3A8A),
                        const Color(0xFF0A0E27),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        verticalSpaceLarge,
                        const Icon(
                          Icons.flutter_dash,
                          size: 80,
                          color: Colors.blueAccent,
                        ),
                        verticalSpaceSmall,
                        Text(
                          AppConfig.conferenceSubtitle,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpaceTiny,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.blueAccent,
                              ),
                              horizontalSpaceTiny,
                              Text(
                                AppConfig.conferenceDates,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: viewModel.viewPaymentHistory,
                  tooltip: 'Payment History',
                ),
              ],
            ),

            // Conference Info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About the Conference',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      'One ticket, 2 conferences. When you buy a ticket to FlutterconKe, '
                      'you are automatically registered to attend droidconKe.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                    verticalSpaceSmall,
                    _buildInfoRow(
                      Icons.location_on,
                      AppConfig.conferenceVenue,
                    ),
                    verticalSpaceTiny,
                    _buildInfoRow(
                      Icons.event_available,
                      'Workshops, Talks, Panels & Networking',
                    ),
                    verticalSpaceMedium,
                    const Text(
                      'Select Your Ticket',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    verticalSpaceSmall,
                  ],
                ),
              ),
            ),

            // Ticket List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ticket = viewModel.availableTickets[index];
                    final isSelected =
                        viewModel.selectedTicket?.id == ticket.id;
                    return _buildTicketCard(
                      context,
                      ticket,
                      isSelected,
                      () => viewModel.selectTicket(ticket),
                    );
                  },
                  childCount: viewModel.availableTickets.length,
                ),
              ),
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      floatingActionButton: viewModel.canProceedToPayment
          ? FloatingActionButton.extended(
              onPressed: viewModel.proceedToPayment,
              backgroundColor: Colors.blueAccent,
              icon: const Icon(Icons.payment),
              label: const Text(
                'Proceed to Payment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.blueAccent,
        ),
        horizontalSpaceTiny,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    TicketType ticket,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0.1),
                  ],
                )
              : null,
          color: isSelected ? null : const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        verticalSpaceTiny,
                        Text(
                          ticket.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ticket.formattedPrice,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      if (ticket.category == TicketCategory.earlyBird)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'LIMITED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              verticalSpaceSmall,
              const Divider(color: Colors.white24),
              verticalSpaceTiny,
              const Text(
                'Includes:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              verticalSpaceTiny,
              ...ticket.benefits.take(3).map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.greenAccent,
                          ),
                          horizontalSpaceTiny,
                          Expanded(
                            child: Text(
                              benefit,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              if (ticket.benefits.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '+ ${ticket.benefits.length - 3} more benefits',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueAccent.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ConferenceHomeViewModel viewModelBuilder(BuildContext context) =>
      ConferenceHomeViewModel();
}
