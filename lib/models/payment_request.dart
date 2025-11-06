class PaymentRequest {
  final String ticketId;
  final String ticketName;
  final double amount;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String email;
  final Map<String, dynamic> metadata;

  PaymentRequest({
    required this.ticketId,
    required this.ticketName,
    required this.amount,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'ticketName': ticketName,
      'amount': amount,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'metadata': metadata,
    };
  }

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      ticketId: json['ticketId'] as String,
      ticketName: json['ticketName'] as String,
      amount: (json['amount'] as num).toDouble(),
      phoneNumber: json['phoneNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}

