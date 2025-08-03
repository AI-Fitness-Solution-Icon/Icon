import 'package:equatable/equatable.dart';
import 'subscription.dart';

/// PaymentHistory model representing payment history in the Icon app
class PaymentHistory extends Equatable {
  static const String tableName = 'payment_history';

  final String paymentId;
  final String subscriptionId;
  final double amount;
  final String currency;
  final DateTime paymentDate;
  final String? stripeInvoiceId;
  final String status;
  
  // Related models (optional, populated when joined)
  final UserSubscription? subscription;

  const PaymentHistory({
    required this.paymentId,
    required this.subscriptionId,
    required this.amount,
    this.currency = 'USD',
    required this.paymentDate,
    this.stripeInvoiceId,
    this.status = 'pending',
    this.subscription,
  });

  /// Creates a PaymentHistory from JSON data
  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      paymentId: json['payment_id'] as String,
      subscriptionId: json['subscription_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      paymentDate: DateTime.parse(json['payment_date'] as String),
      stripeInvoiceId: json['stripe_invoice_id'] as String?,
      status: json['status'] as String? ?? 'pending',
      subscription: json['subscription'] != null 
          ? UserSubscription.fromJson(json['subscription'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts PaymentHistory to JSON data
  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'subscription_id': subscriptionId,
      'amount': amount,
      'currency': currency,
      'payment_date': paymentDate.toIso8601String(),
      'stripe_invoice_id': stripeInvoiceId,
      'status': status,
      'subscription': subscription?.toJson(),
    };
  }

  /// Creates a copy of PaymentHistory with updated fields
  PaymentHistory copyWith({
    String? paymentId,
    String? subscriptionId,
    double? amount,
    String? currency,
    DateTime? paymentDate,
    String? stripeInvoiceId,
    String? status,
    UserSubscription? subscription,
  }) {
    return PaymentHistory(
      paymentId: paymentId ?? this.paymentId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentDate: paymentDate ?? this.paymentDate,
      stripeInvoiceId: stripeInvoiceId ?? this.stripeInvoiceId,
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
    );
  }

  /// Checks if payment is successful
  bool get isSuccessful => status == 'completed';

  /// Checks if payment is pending
  bool get isPending => status == 'pending';

  /// Checks if payment failed
  bool get isFailed => status == 'failed';

  @override
  List<Object?> get props => [
    paymentId,
    subscriptionId,
    amount,
    currency,
    paymentDate,
    stripeInvoiceId,
    status,
    subscription,
  ];

  @override
  String toString() {
    return 'PaymentHistory(paymentId: $paymentId, amount: $amount, currency: $currency, status: $status)';
  }
} 