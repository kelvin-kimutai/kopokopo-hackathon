import 'payment_request.dart';

enum PaymentStatus {
  pending,
  processing,
  success,
  failed,
  cancelled,
}

class PaymentRecord {
  final String id;
  final String locationUrl;
  final PaymentRequest paymentRequest;
  final PaymentStatus status;
  final DateTime createdAt;
  final String? errorMessage;
  final String? transactionReference;

  PaymentRecord({
    required this.id,
    required this.locationUrl,
    required this.paymentRequest,
    required this.status,
    required this.createdAt,
    this.errorMessage,
    this.transactionReference,
  });

  PaymentRecord copyWith({
    String? id,
    String? locationUrl,
    PaymentRequest? paymentRequest,
    PaymentStatus? status,
    DateTime? createdAt,
    String? errorMessage,
    String? transactionReference,
  }) {
    return PaymentRecord(
      id: id ?? this.id,
      locationUrl: locationUrl ?? this.locationUrl,
      paymentRequest: paymentRequest ?? this.paymentRequest,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      errorMessage: errorMessage ?? this.errorMessage,
      transactionReference: transactionReference ?? this.transactionReference,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationUrl': locationUrl,
      'paymentRequest': paymentRequest.toJson(),
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'errorMessage': errorMessage,
      'transactionReference': transactionReference,
    };
  }

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['id'] as String,
      locationUrl: json['locationUrl'] as String,
      paymentRequest: PaymentRequest.fromJson(json['paymentRequest'] as Map<String, dynamic>),
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      errorMessage: json['errorMessage'] as String?,
      transactionReference: json['transactionReference'] as String?,
    );
  }

  String get statusText {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

