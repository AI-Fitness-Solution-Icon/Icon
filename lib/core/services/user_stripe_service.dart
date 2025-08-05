import 'package:flutter_stripe/flutter_stripe.dart';
import '../utils/app_print.dart';
import '../models/subscription.dart';
import '../models/subscription_plan.dart';
import 'stripe_service.dart';

/// User-friendly Stripe service that provides easy access to core payment functionality
/// This service handles the UI interactions and provides a simple interface for users
class UserStripeService {
  static UserStripeService? _instance;
  final StripeService _stripeService = StripeService.instance;

  UserStripeService._();

  /// Singleton instance of UserStripeService
  static UserStripeService get instance {
    _instance ??= UserStripeService._();
    return _instance!;
  }

  /// Initialize the user Stripe service
  static Future<void> initialize() async {
    await StripeService.initialize();
  }

  /// Subscribe to a plan with a simple interface
  Future<UserSubscription?> subscribeToPlan({
    required SubscriptionPlan plan,
    required String customerId,
    String? customerEmail,
    String? customerName,
  }) async {
    try {
      AppPrint.printInfo('Starting subscription process for plan: ${plan.name}');

      // Create billing details
      final billingDetails = BillingDetails(
        email: customerEmail,
        name: customerName,
      );

      // Create payment method
      await _stripeService.createPaymentMethod(
        billingDetails: billingDetails,
      );

      // Process subscription payment
      final subscription = await _stripeService.processSubscriptionPayment(
        customerId: customerId,
        priceId: plan.planId, // This should be the Stripe price ID
        paymentMethodParams: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
        metadata: {
          'plan_name': plan.name,
          'plan_id': plan.planId,
          'billing_cycle': plan.billingCycle,
        },
      );

      if (subscription != null) {
        AppPrint.printInfo('Subscription created successfully: ${subscription.subscriptionId}');
        return subscription;
      } else {
        throw Exception('Failed to create subscription');
      }
    } catch (e) {
      AppPrint.printError('Failed to subscribe to plan: $e');
      return null;
    }
  }

  /// Make a one-time payment
  Future<bool> makeOneTimePayment({
    required double amount,
    required String currency,
    required String customerId,
    String? description,
    String? customerEmail,
    String? customerName,
  }) async {
    try {
      AppPrint.printInfo('Starting one-time payment: $amount $currency');

      // Convert amount to cents
      final amountInCents = (amount * 100).round();

      // Create billing details
      final billingDetails = BillingDetails(
        email: customerEmail,
        name: customerName,
      );

      // Process payment
      final success = await _stripeService.processOneTimePayment(
        amount: amountInCents,
        currency: currency,
        paymentMethodParams: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
        customerId: customerId,
        description: description,
        metadata: {
          'payment_type': 'one_time',
          'description': description ?? 'One-time payment',
        },
      );

      if (success) {
        AppPrint.printInfo('One-time payment completed successfully');
        return true;
      } else {
        throw Exception('Payment failed');
      }
    } catch (e) {
      AppPrint.printError('One-time payment failed: $e');
      return false;
    }
  }

  /// Cancel a subscription with confirmation
  Future<bool> cancelSubscription({
    required String subscriptionId,
  }) async {
    try {
      AppPrint.printInfo('Cancelling subscription: $subscriptionId');

      // Cancel subscription
      await _stripeService.cancelSubscription(subscriptionId);

      AppPrint.printInfo('Subscription cancelled successfully: $subscriptionId');
      return true;
    } catch (e) {
      AppPrint.printError('Failed to cancel subscription: $e');
      return false;
    }
  }

  /// Update payment method
  Future<bool> updatePaymentMethod({
    required String customerId,
    String? customerEmail,
    String? customerName,
  }) async {
    try {
      AppPrint.printInfo('Updating payment method for customer: $customerId');

      // Create new payment method
      final billingDetails = BillingDetails(
        email: customerEmail,
        name: customerName,
      );

      final paymentMethod = await _stripeService.createPaymentMethod(
        billingDetails: billingDetails,
      );

      AppPrint.printInfo('Payment method updated successfully: ${paymentMethod.id}');
      return true;
    } catch (e) {
      AppPrint.printError('Failed to update payment method: $e');
      return false;
    }
  }

  /// Get customer payment methods
  Future<List<PaymentMethod>> getPaymentMethods({
    required String customerId,
  }) async {
    try {
      AppPrint.printInfo('Getting payment methods for customer: $customerId');

      final paymentMethods = await _stripeService.getCustomerPaymentMethods(customerId);
      
      AppPrint.printInfo('Retrieved ${paymentMethods.length} payment methods');
      return paymentMethods;
    } catch (e) {
      AppPrint.printError('Failed to get payment methods: $e');
      return [];
    }
  }

  /// Delete a payment method
  Future<bool> deletePaymentMethod({
    required String paymentMethodId,
  }) async {
    try {
      AppPrint.printInfo('Deleting payment method: $paymentMethodId');

      // Delete payment method
      await _stripeService.deletePaymentMethod(paymentMethodId);

      AppPrint.printInfo('Payment method deleted successfully: $paymentMethodId');
      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete payment method: $e');
      return false;
    }
  }

  /// Format currency amount for display
  String formatCurrency(double amount, String currency) {
    return _stripeService.formatAmount((amount * 100).round(), currency);
  }

  /// Check if Stripe is ready for use
  bool get isReady => _stripeService.isInitialized;
} 