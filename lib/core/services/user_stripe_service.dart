import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../constants/app_colors.dart';
import '../utils/app_print.dart';
import '../utils/snackbar.dart';
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
    required BuildContext context,
    required SubscriptionPlan plan,
    required String customerId,
    String? customerEmail,
    String? customerName,
  }) async {
    try {
      AppPrint.printInfo('Starting subscription process for plan: ${plan.name}');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
          ),
        ),
      );

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

      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (subscription != null) {
        // Show success message
        if (context.mounted) {
          AppSnackBar.showSuccessText(
            context,
            message: 'Successfully subscribed to ${plan.name}!',
          );
        }
        
        AppPrint.printInfo('Subscription created successfully: ${subscription.subscriptionId}');
        return subscription;
      } else {
        throw Exception('Failed to create subscription');
      }
    } catch (e) {
      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        AppSnackBar.showDangerText(
          context,
          message: 'Failed to subscribe: ${e.toString()}',
        );
      }

      AppPrint.printError('Subscription failed: $e');
      return null;
    }
  }

  /// Make a one-time payment
  Future<bool> makeOneTimePayment({
    required BuildContext context,
    required double amount,
    required String currency,
    required String customerId,
    String? description,
    String? customerEmail,
    String? customerName,
  }) async {
    try {
      AppPrint.printInfo('Starting one-time payment: $amount $currency');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
          ),
        ),
      );

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

      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (success) {
        // Show success message
        if (context.mounted) {
          AppSnackBar.showSuccessText(
            context,
            message: 'Payment successful!',
          );
        }
        
        AppPrint.printInfo('One-time payment completed successfully');
        return true;
      } else {
        throw Exception('Payment failed');
      }
    } catch (e) {
      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        AppSnackBar.showDangerText(
          context,
          message: 'Payment failed: ${e.toString()}',
        );
      }

      AppPrint.printError('One-time payment failed: $e');
      return false;
    }
  }

  /// Cancel a subscription with confirmation
  Future<bool> cancelSubscription({
    required BuildContext context,
    required String subscriptionId,
    required String subscriptionName,
  }) async {
    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          title: const Text(
            'Cancel Subscription',
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel your $subscriptionName subscription? You will lose access to premium features at the end of your current billing period.',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Keep Subscription',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel Subscription'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return false;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
          ),
        ),
      );

      // Cancel subscription
      await _stripeService.cancelSubscription(subscriptionId);

      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (context.mounted) {
        AppSnackBar.showSuccessText(
          context,
          message: 'Subscription cancelled successfully. You will have access until the end of your billing period.',
        );
      }

      AppPrint.printInfo('Subscription cancelled successfully: $subscriptionId');
      return true;
    } catch (e) {
      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        AppSnackBar.showDangerText(
          context,
          message: 'Failed to cancel subscription: ${e.toString()}',
        );
      }

      AppPrint.printError('Failed to cancel subscription: $e');
      return false;
    }
  }

  /// Update payment method
  Future<bool> updatePaymentMethod({
    required BuildContext context,
    required String customerId,
    String? customerEmail,
    String? customerName,
  }) async {
    try {
      AppPrint.printInfo('Updating payment method for customer: $customerId');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
          ),
        ),
      );

      // Create new payment method
      final billingDetails = BillingDetails(
        email: customerEmail,
        name: customerName,
      );

      final paymentMethod = await _stripeService.createPaymentMethod(
        billingDetails: billingDetails,
      );

      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (context.mounted) {
        AppSnackBar.showSuccessText(
          context,
          message: 'Payment method updated successfully!',
        );
      }

      AppPrint.printInfo('Payment method updated successfully: ${paymentMethod.id}');
      return true;
    } catch (e) {
      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        AppSnackBar.showDangerText(
          context,
          message: 'Failed to update payment method: ${e.toString()}',
        );
      }

      AppPrint.printError('Failed to update payment method: $e');
      return false;
    }
  }

  /// Get customer payment methods
  Future<List<PaymentMethod>> getPaymentMethods({
    required BuildContext context,
    required String customerId,
  }) async {
    try {
      AppPrint.printInfo('Getting payment methods for customer: $customerId');

      final paymentMethods = await _stripeService.getCustomerPaymentMethods(customerId);
      
      AppPrint.printInfo('Retrieved ${paymentMethods.length} payment methods');
      return paymentMethods;
    } catch (e) {
      // Show error message
      if (context.mounted) {
        AppSnackBar.showDangerText(
          context,
          message: 'Failed to load payment methods: ${e.toString()}',
        );
      }

      AppPrint.printError('Failed to get payment methods: $e');
      return [];
    }
  }

  /// Delete a payment method with confirmation
  Future<bool> deletePaymentMethod({
    required BuildContext context,
    required String paymentMethodId,
  }) async {
    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          title: const Text(
            'Delete Payment Method',
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this payment method? This action cannot be undone.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return false;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
          ),
        ),
      );

      // Delete payment method
      await _stripeService.deletePaymentMethod(paymentMethodId);

      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (context.mounted) {
        AppSnackBar.showSuccessText(
          context,
          message: 'Payment method deleted successfully!',
        );
      }

      AppPrint.printInfo('Payment method deleted successfully: $paymentMethodId');
      return true;
    } catch (e) {
      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        AppSnackBar.showDangerText(
          context,
          message: 'Failed to delete payment method: ${e.toString()}',
        );
      }

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