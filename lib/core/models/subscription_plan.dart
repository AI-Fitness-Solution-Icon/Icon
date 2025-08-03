import 'package:equatable/equatable.dart';

/// SubscriptionPlan model representing a subscription plan in the Icon app
class SubscriptionPlan extends Equatable {
  static const String tableName = 'subscription_plans';

  final String planId;
  final String name;
  final String? description;
  final double price;
  final String billingCycle;
  final Map<String, dynamic> features;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionPlan({
    required this.planId,
    required this.name,
    this.description,
    required this.price,
    this.billingCycle = 'monthly',
    this.features = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a SubscriptionPlan from JSON data
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      planId: json['plan_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      billingCycle: json['billing_cycle'] as String? ?? 'monthly',
      features: json['features'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts SubscriptionPlan to JSON data
  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'name': name,
      'description': description,
      'price': price,
      'billing_cycle': billingCycle,
      'features': features,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of SubscriptionPlan with updated fields
  SubscriptionPlan copyWith({
    String? planId,
    String? name,
    String? description,
    double? price,
    String? billingCycle,
    Map<String, dynamic>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlan(
      planId: planId ?? this.planId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    planId,
    name,
    description,
    price,
    billingCycle,
    features,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'SubscriptionPlan(planId: $planId, name: $name, price: $price, billingCycle: $billingCycle)';
  }
} 