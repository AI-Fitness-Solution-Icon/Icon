import 'package:flutter_stripe/flutter_stripe.dart';
import '../constants/api_config.dart';
import '../utils/app_print.dart';

/// Stripe service for payment processing
class StripeService {
  static StripeService? _instance;
  bool _isInitialized = false;

  StripeService._();

  /// Singleton instance of StripeService
  static StripeService get instance {
    _instance ??= StripeService._();
    return _instance!;
  }

  /// Initialize Stripe with configuration
  static Future<void> initialize() async {
    Stripe.publishableKey = ApiConfig.stripePublishableKey;
    await Stripe.instance.applySettings();
    instance._isInitialized = true;
  }

  /// Check if Stripe is initialized
  bool get isInitialized => _isInitialized;

  /// Create a payment method
  Future<PaymentMethod> createPaymentMethod({
    required BillingDetails billingDetails,
  }) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      return paymentMethod;
    } catch (e) {
      throw Exception('Failed to create payment method: $e');
    }
  }

  /// Present payment sheet for Apple Pay/Google Pay
  Future<void> presentPaymentSheet({
    required String paymentIntentClientSecret,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet(
        options: PaymentSheetPresentOptions(),
      );
    } catch (e) {
      throw Exception('Failed to present payment sheet: $e');
    }
  }

  /// Create a subscription (mock implementation)
  Future<StripeSubscription> createSubscription({
    required String customerId,
    required String priceId,
    String? paymentMethodId,
  }) async {
    try {
      // This would typically be done on the server side
      // For now, we'll return a mock subscription
      return StripeSubscription(
        id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
        customerId: customerId,
        priceId: priceId,
        status: StripeSubscriptionStatus.active,
        currentPeriodStart: DateTime.now(),
        currentPeriodEnd: DateTime.now().add(const Duration(days: 30)),
      );
    } catch (e) {
      AppPrint.printError('Failed to create subscription: $e');
      throw Exception('Failed to create subscription: $e');
    }
  }

  /// Cancel a subscription
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      // This would typically be done on the server side
      AppPrint.printInfo('Cancelling subscription: $subscriptionId');
    } catch (e) {
      AppPrint.printError('Failed to cancel subscription: $e');
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  /// Get customer payment methods
  Future<List<PaymentMethod>> getCustomerPaymentMethods(String customerId) async {
    try {
      // This would typically be done on the server side
      // For now, we'll return an empty list
      return [];
    } catch (e) {
      throw Exception('Failed to get customer payment methods: $e');
    }
  }

  /// Delete a payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      // This would typically be done on the server side
      AppPrint.printInfo('Deleting payment method: $paymentMethodId');
    } catch (e) {
      AppPrint.printError('Failed to delete payment method: $e');
      throw Exception('Failed to delete payment method: $e');
    }
  }
}

/// Mock StripeSubscription class for demonstration
class StripeSubscription {
  final String id;
  final String customerId;
  final String priceId;
  final StripeSubscriptionStatus status;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;

  const StripeSubscription({
    required this.id,
    required this.customerId,
    required this.priceId,
    required this.status,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
  });
}

/// Stripe subscription status enum
enum StripeSubscriptionStatus {
  active,
  cancelled,
  pastDue,
  unpaid,
} 