import 'package:equatable/equatable.dart';
import 'user.dart';
import 'subscription_plan.dart';

/// UserSubscription model representing a user's subscription in the Icon app
class UserSubscription extends Equatable {
  static const String tableName = 'user_subscriptions';

  final String subscriptionId;
  final String userId;
  final String planId;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;
  final String? stripeSubscriptionId;
  
  // Related models (optional, populated when joined)
  final User? user;
  final SubscriptionPlan? plan;

  const UserSubscription({
    required this.subscriptionId,
    required this.userId,
    required this.planId,
    required this.startDate,
    this.endDate,
    this.status = 'active',
    this.stripeSubscriptionId,
    this.user,
    this.plan,
  });

  /// Creates a UserSubscription from JSON data
  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      subscriptionId: json['subscription_id'] as String,
      userId: json['user_id'] as String,
      planId: json['plan_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'] as String) 
          : null,
      status: json['status'] as String? ?? 'active',
      stripeSubscriptionId: json['stripe_subscription_id'] as String?,
      user: json['user'] != null 
          ? User.fromJson(json['user'] as Map<String, dynamic>) 
          : null,
      plan: json['plan'] != null 
          ? SubscriptionPlan.fromJson(json['plan'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts UserSubscription to JSON data
  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'user_id': userId,
      'plan_id': planId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'stripe_subscription_id': stripeSubscriptionId,
      'user': user?.toJson(),
      'plan': plan?.toJson(),
    };
  }

  /// Creates a copy of UserSubscription with updated fields
  UserSubscription copyWith({
    String? subscriptionId,
    String? userId,
    String? planId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? stripeSubscriptionId,
    User? user,
    SubscriptionPlan? plan,
  }) {
    return UserSubscription(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      stripeSubscriptionId: stripeSubscriptionId ?? this.stripeSubscriptionId,
      user: user ?? this.user,
      plan: plan ?? this.plan,
    );
  }

  /// Checks if subscription is active
  bool get isActive => status == 'active';

  /// Checks if subscription is expired
  bool get isExpired => endDate != null && endDate!.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
    subscriptionId,
    userId,
    planId,
    startDate,
    endDate,
    status,
    stripeSubscriptionId,
    user,
    plan,
  ];

  @override
  String toString() {
    return 'UserSubscription(subscriptionId: $subscriptionId, userId: $userId, status: $status)';
  }
}

/// Subscription status types
enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  pending,
  pastDue,
} 