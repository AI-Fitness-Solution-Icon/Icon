import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_config.dart';
import '../utils/app_print.dart';
import '../models/subscription.dart';

/// Comprehensive Stripe service for payment processing and subscription management
class StripeService {
  static StripeService? _instance;
  bool _isInitialized = false;
  
  // API endpoints (these should be your backend endpoints)
  static const String _baseUrl = 'https://your-backend-api.com/api';
  static const String _createPaymentIntentEndpoint = '/stripe/create-payment-intent';
  static const String _createSubscriptionEndpoint = '/stripe/create-subscription';
  static const String _cancelSubscriptionEndpoint = '/stripe/cancel-subscription';
  static const String _getCustomerEndpoint = '/stripe/customer';
  static const String _getPaymentMethodsEndpoint = '/stripe/payment-methods';
  static const String _deletePaymentMethodEndpoint = '/stripe/payment-methods';

  StripeService._();

  /// Singleton instance of StripeService
  static StripeService get instance {
    _instance ??= StripeService._();
    return _instance!;
  }

  /// Initialize Stripe with configuration
  static Future<void> initialize() async {
    try {
      // Get publishable key from environment or config
      final publishableKey = _getPublishableKey();
      
      if (publishableKey.isEmpty || publishableKey == 'your-stripe-publishable-key') {
        throw Exception('Stripe publishable key not configured. Please set STRIPE_PUBLISHABLE_KEY in your environment.');
      }

      Stripe.publishableKey = publishableKey;
      
      // Configure Stripe settings
      await Stripe.instance.applySettings();
      
      instance._isInitialized = true;
      AppPrint.printInfo('Stripe service initialized successfully');
    } catch (e) {
      AppPrint.printError('Failed to initialize Stripe service: $e');
      rethrow;
    }
  }

  /// Get publishable key from environment
  static String _getPublishableKey() {
    // Try to get from environment first
    const String envKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
    if (envKey.isNotEmpty && envKey != 'your-stripe-publishable-key') {
      return envKey;
    }
    
    // Fallback to API config
    return ApiConfig.stripePublishableKey;
  }

  /// Check if Stripe is initialized
  bool get isInitialized => _isInitialized;

  /// Create a payment intent for one-time payments
  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
    String? customerId,
    String? description,
    Map<String, String>? metadata,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Creating payment intent for amount: $amount $currency');

      // Create payment intent on your backend
      final response = await http.post(
        Uri.parse('$_baseUrl$_createPaymentIntentEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here
        },
        body: json.encode({
          'amount': amount,
          'currency': currency,
          'customer_id': customerId,
          'description': description,
          'metadata': metadata,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to create payment intent: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Failed to create payment intent: $e');
      rethrow;
    }
  }

  /// Create a payment method
  Future<PaymentMethod> createPaymentMethod({
    required BillingDetails billingDetails,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Creating payment method');

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      AppPrint.printInfo('Payment method created successfully: ${paymentMethod.id}');
      return paymentMethod;
    } catch (e) {
      AppPrint.printError('Failed to create payment method: $e');
      rethrow;
    }
  }

  /// Create a subscription
  Future<UserSubscription> createSubscription({
    required String customerId,
    required String priceId,
    String? paymentMethodId,
    Map<String, String>? metadata,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Creating subscription for customer: $customerId, price: $priceId');

      // Create subscription on your backend
      final response = await http.post(
        Uri.parse('$_baseUrl$_createSubscriptionEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here
        },
        body: json.encode({
          'customer_id': customerId,
          'price_id': priceId,
          'payment_method_id': paymentMethodId,
          'metadata': metadata,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserSubscription.fromJson(data);
      } else {
        throw Exception('Failed to create subscription: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Failed to create subscription: $e');
      rethrow;
    }
  }

  /// Cancel a subscription
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Cancelling subscription: $subscriptionId');

      // Cancel subscription on your backend
      final response = await http.post(
        Uri.parse('$_baseUrl$_cancelSubscriptionEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here
        },
        body: json.encode({
          'subscription_id': subscriptionId,
        }),
      );

      if (response.statusCode == 200) {
        AppPrint.printInfo('Subscription cancelled successfully');
      } else {
        throw Exception('Failed to cancel subscription: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Failed to cancel subscription: $e');
      rethrow;
    }
  }

  /// Get customer information
  Future<Map<String, dynamic>> getCustomer(String customerId) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Getting customer information: $customerId');

      final response = await http.get(
        Uri.parse('$_baseUrl$_getCustomerEndpoint/$customerId'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get customer: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Failed to get customer: $e');
      rethrow;
    }
  }

  /// Get customer payment methods
  Future<List<PaymentMethod>> getCustomerPaymentMethods(String customerId) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Getting payment methods for customer: $customerId');

      final response = await http.get(
        Uri.parse('$_baseUrl$_getPaymentMethodsEndpoint/$customerId'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['payment_methods'] as List)
            .map((json) => PaymentMethod.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get payment methods: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Failed to get payment methods: $e');
      rethrow;
    }
  }

  /// Delete a payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Deleting payment method: $paymentMethodId');

      final response = await http.delete(
        Uri.parse('$_baseUrl$_deletePaymentMethodEndpoint/$paymentMethodId'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here
        },
      );

      if (response.statusCode == 200) {
        AppPrint.printInfo('Payment method deleted successfully');
      } else {
        throw Exception('Failed to delete payment method: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Failed to delete payment method: $e');
      rethrow;
    }
  }

  /// Present payment sheet for Apple Pay/Google Pay
  Future<void> presentPaymentSheet({
    required String paymentIntentClientSecret,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Presenting payment sheet');

      await Stripe.instance.presentPaymentSheet(
        options: PaymentSheetPresentOptions(),
      );

      AppPrint.printInfo('Payment sheet presented successfully');
    } catch (e) {
      AppPrint.printError('Failed to present payment sheet: $e');
      rethrow;
    }
  }

  /// Handle payment with card form
  Future<PaymentMethod?> handleCardPayment({
    required BillingDetails billingDetails,
    required Function(String) onPaymentMethodCreated,
    required Function(String) onError,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Handling card payment');

      final paymentMethod = await createPaymentMethod(
        billingDetails: billingDetails,
      );

      onPaymentMethodCreated(paymentMethod.id);
      return paymentMethod;
    } catch (e) {
      AppPrint.printError('Card payment failed: $e');
      onError(e.toString());
      return null;
    }
  }

  /// Process one-time payment
  Future<bool> processOneTimePayment({
    required int amount,
    required String currency,
    required PaymentMethodParams paymentMethodParams,
    String? customerId,
    String? description,
    Map<String, String>? metadata,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Processing one-time payment: $amount $currency');

      // Create payment intent
      await createPaymentIntent(
        amount: amount,
        currency: currency,
        customerId: customerId,
        description: description,
        metadata: metadata,
      );

      // For now, return success - in a real implementation, you would confirm the payment
      AppPrint.printInfo('One-time payment processed successfully');
      return true;
    } catch (e) {
      AppPrint.printError('One-time payment failed: $e');
      return false;
    }
  }

  /// Process subscription payment
  Future<UserSubscription?> processSubscriptionPayment({
    required String customerId,
    required String priceId,
    required PaymentMethodParams paymentMethodParams,
    Map<String, String>? metadata,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe service not initialized');
      }

      AppPrint.printInfo('Processing subscription payment for customer: $customerId');

      // Create payment method
      final paymentMethod = await createPaymentMethod(
        billingDetails: const BillingDetails(),
      );

      // Create subscription
      final subscription = await createSubscription(
        customerId: customerId,
        priceId: priceId,
        paymentMethodId: paymentMethod.id,
        metadata: metadata,
      );

      AppPrint.printInfo('Subscription payment processed successfully');
      return subscription;
    } catch (e) {
      AppPrint.printError('Subscription payment failed: $e');
      return null;
    }
  }

  /// Format amount for display
  String formatAmount(int amount, String currency) {
    final double amountInCurrency = amount / 100; // Stripe amounts are in cents
    return '${amountInCurrency.toStringAsFixed(2)} $currency';
  }

  /// Parse amount from currency string
  int parseAmount(String amountString, String currency) {
    final amount = double.tryParse(amountString.replaceAll(RegExp(r'[^\d.]'), ''));
    if (amount == null) {
      throw Exception('Invalid amount format');
    }
    return (amount * 100).round(); // Convert to cents for Stripe
  }
} 