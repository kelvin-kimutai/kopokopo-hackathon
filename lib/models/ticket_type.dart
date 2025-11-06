enum TicketCategory {
  earlyBird,
  regular,
  student,
  corporate,
}

class TicketType {
  final String id;
  final String name;
  final String description;
  final double price;
  final TicketCategory category;
  final List<String> benefits;
  final bool isAvailable;

  const TicketType({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.benefits,
    this.isAvailable = true,
  });

  static const List<TicketType> availableTickets = [
    TicketType(
      id: 'early_bird',
      name: 'Early Bird Ticket',
      description: 'Limited time offer! Get access to both FlutterconKe and DroidconKe',
      price: 5000.00,
      category: TicketCategory.earlyBird,
      benefits: [
        'Access to all workshops',
        'Access to all talks and panels',
        'Networking party access',
        'Office hours with experts',
        'Conference swag',
        'Lunch and refreshments',
        'Both FlutterconKe & DroidconKe access',
      ],
    ),
    TicketType(
      id: 'regular',
      name: 'Regular Ticket',
      description: 'Full conference access to FlutterconKe and DroidconKe',
      price: 7500.00,
      category: TicketCategory.regular,
      benefits: [
        'Access to all workshops',
        'Access to all talks and panels',
        'Networking party access',
        'Office hours with experts',
        'Conference swag',
        'Lunch and refreshments',
        'Both FlutterconKe & DroidconKe access',
      ],
    ),
    TicketType(
      id: 'student',
      name: 'Student Ticket',
      description: 'Special discounted rate for students (ID required)',
      price: 3000.00,
      category: TicketCategory.student,
      benefits: [
        'Access to all workshops',
        'Access to all talks and panels',
        'Networking party access',
        'Conference swag',
        'Lunch and refreshments',
        'Both FlutterconKe & DroidconKe access',
      ],
    ),
    TicketType(
      id: 'corporate',
      name: 'Corporate Package',
      description: 'Premium package for corporate teams (5+ tickets)',
      price: 30000.00,
      category: TicketCategory.corporate,
      benefits: [
        'Access for 5 team members',
        'All workshop access',
        'All talks and panels',
        'VIP networking party access',
        'Priority office hours',
        'Premium conference swag',
        'Catered meals',
        'Both FlutterconKe & DroidconKe access',
        'Logo on conference materials',
      ],
    ),
  ];

  String get formattedPrice {
    return 'KES ${price.toStringAsFixed(2)}';
  }
}

