import '../../../core/models/subscription_plan.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/app_print.dart';

/// Repository for SubscriptionPlan model operations
class SubscriptionPlanRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  static const String _tableName = 'subscription_plans';

  /// Get all subscription plans
  Future<List<SubscriptionPlan>> getAllSubscriptionPlans() async {
    try {
      AppPrint.printStep('Fetching all subscription plans');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final plans = response
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      AppPrint.printPerformance(
        'Get all subscription plans',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${plans.length} subscription plans',
      );

      return plans;
    } catch (e) {
      AppPrint.printError('Failed to fetch subscription plans: $e');
      rethrow;
    }
  }

  /// Get subscription plan by ID
  Future<SubscriptionPlan?> getSubscriptionPlanById(String planId) async {
    try {
      AppPrint.printStep('Fetching subscription plan by ID: $planId');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'plan_id': planId},
      );

      if (response.isEmpty) {
        AppPrint.printWarning('Subscription plan not found with ID: $planId');
        return null;
      }

      final plan = SubscriptionPlan.fromJson(response.first);

      AppPrint.printPerformance(
        'Get subscription plan by ID',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched subscription plan: ${plan.name}',
      );

      return plan;
    } catch (e) {
      AppPrint.printError('Failed to fetch subscription plan by ID: $e');
      rethrow;
    }
  }

  /// Get subscription plans by billing cycle
  Future<List<SubscriptionPlan>> getSubscriptionPlansByBillingCycle(
    String billingCycle,
  ) async {
    try {
      AppPrint.printStep(
        'Fetching subscription plans by billing cycle: $billingCycle',
      );
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'billing_cycle': billingCycle},
      );

      final plans = response
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      AppPrint.printPerformance(
        'Get subscription plans by billing cycle',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${plans.length} subscription plans with billing cycle: $billingCycle',
      );

      return plans;
    } catch (e) {
      AppPrint.printError(
        'Failed to fetch subscription plans by billing cycle: $e',
      );
      rethrow;
    }
  }

  /// Get subscription plans by price range
  Future<List<SubscriptionPlan>> getSubscriptionPlansByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      AppPrint.printStep(
        'Fetching subscription plans by price range: \$$minPrice-\$$maxPrice',
      );
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final plans = response
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      // Filter plans by price range
      final filteredPlans = plans.where((plan) {
        return plan.price >= minPrice && plan.price <= maxPrice;
      }).toList();

      AppPrint.printPerformance(
        'Get subscription plans by price range',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${filteredPlans.length} subscription plans in price range: \$$minPrice-\$$maxPrice',
      );

      return filteredPlans;
    } catch (e) {
      AppPrint.printError(
        'Failed to fetch subscription plans by price range: $e',
      );
      rethrow;
    }
  }

  /// Get monthly subscription plans
  Future<List<SubscriptionPlan>> getMonthlySubscriptionPlans() async {
    try {
      AppPrint.printStep('Fetching monthly subscription plans');
      return await getSubscriptionPlansByBillingCycle('monthly');
    } catch (e) {
      AppPrint.printError('Failed to fetch monthly subscription plans: $e');
      rethrow;
    }
  }

  /// Get yearly subscription plans
  Future<List<SubscriptionPlan>> getYearlySubscriptionPlans() async {
    try {
      AppPrint.printStep('Fetching yearly subscription plans');
      return await getSubscriptionPlansByBillingCycle('yearly');
    } catch (e) {
      AppPrint.printError('Failed to fetch yearly subscription plans: $e');
      rethrow;
    }
  }

  /// Create a new subscription plan
  Future<SubscriptionPlan> createSubscriptionPlan({
    required String name,
    String? description,
    required double price,
    String? billingCycle,
    Map<String, dynamic>? features,
  }) async {
    try {
      AppPrint.printStep('Creating new subscription plan: $name');
      final startTime = DateTime.now();

      final planData = {
        'name': name,
        'description': description,
        'price': price,
        'billing_cycle': billingCycle ?? 'monthly',
        'features': features ?? {},
      };

      final response = await _supabaseService.insertData(
        table: _tableName,
        data: planData,
      );

      final plan = SubscriptionPlan.fromJson(response.first);

      AppPrint.printPerformance(
        'Create subscription plan',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully created subscription plan: ${plan.name}',
      );

      return plan;
    } catch (e) {
      AppPrint.printError('Failed to create subscription plan: $e');
      rethrow;
    }
  }

  /// Update subscription plan
  Future<SubscriptionPlan?> updateSubscriptionPlan(
    String planId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      AppPrint.printStep('Updating subscription plan: $planId');
      final startTime = DateTime.now();

      // Add updated_at timestamp
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabaseService.client
          .from(_tableName)
          .update(updateData)
          .eq('plan_id', planId)
          .select();

      if (response.isEmpty) {
        AppPrint.printWarning(
          'Subscription plan not found for update with ID: $planId',
        );
        return null;
      }

      final plan = SubscriptionPlan.fromJson(response.first);

      AppPrint.printPerformance(
        'Update subscription plan',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully updated subscription plan: ${plan.name}',
      );

      return plan;
    } catch (e) {
      AppPrint.printError('Failed to update subscription plan: $e');
      rethrow;
    }
  }

  /// Update subscription plan name
  Future<SubscriptionPlan?> updateSubscriptionPlanName(
    String planId,
    String name,
  ) async {
    try {
      AppPrint.printStep('Updating subscription plan name: $planId');

      final updateData = {'name': name};

      return await updateSubscriptionPlan(planId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update subscription plan name: $e');
      rethrow;
    }
  }

  /// Update subscription plan description
  Future<SubscriptionPlan?> updateSubscriptionPlanDescription(
    String planId,
    String description,
  ) async {
    try {
      AppPrint.printStep('Updating subscription plan description: $planId');

      final updateData = {'description': description};

      return await updateSubscriptionPlan(planId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update subscription plan description: $e');
      rethrow;
    }
  }

  /// Update subscription plan price
  Future<SubscriptionPlan?> updateSubscriptionPlanPrice(
    String planId,
    double price,
  ) async {
    try {
      AppPrint.printStep('Updating subscription plan price: $planId');

      final updateData = {'price': price};

      return await updateSubscriptionPlan(planId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update subscription plan price: $e');
      rethrow;
    }
  }

  /// Update subscription plan billing cycle
  Future<SubscriptionPlan?> updateSubscriptionPlanBillingCycle(
    String planId,
    String billingCycle,
  ) async {
    try {
      AppPrint.printStep('Updating subscription plan billing cycle: $planId');

      final updateData = {'billing_cycle': billingCycle};

      return await updateSubscriptionPlan(planId, updateData);
    } catch (e) {
      AppPrint.printError(
        'Failed to update subscription plan billing cycle: $e',
      );
      rethrow;
    }
  }

  /// Update subscription plan features
  Future<SubscriptionPlan?> updateSubscriptionPlanFeatures(
    String planId,
    Map<String, dynamic> features,
  ) async {
    try {
      AppPrint.printStep('Updating subscription plan features: $planId');

      final updateData = {'features': features};

      return await updateSubscriptionPlan(planId, updateData);
    } catch (e) {
      AppPrint.printError('Failed to update subscription plan features: $e');
      rethrow;
    }
  }

  /// Add feature to subscription plan
  Future<SubscriptionPlan?> addFeatureToSubscriptionPlan(
    String planId,
    String featureKey,
    dynamic featureValue,
  ) async {
    try {
      AppPrint.printStep('Adding feature to subscription plan: $planId');

      final currentPlan = await getSubscriptionPlanById(planId);
      if (currentPlan == null) {
        AppPrint.printWarning('Subscription plan not found: $planId');
        return null;
      }

      final updatedFeatures = Map<String, dynamic>.from(currentPlan.features);
      updatedFeatures[featureKey] = featureValue;

      return await updateSubscriptionPlanFeatures(planId, updatedFeatures);
    } catch (e) {
      AppPrint.printError('Failed to add feature to subscription plan: $e');
      rethrow;
    }
  }

  /// Remove feature from subscription plan
  Future<SubscriptionPlan?> removeFeatureFromSubscriptionPlan(
    String planId,
    String featureKey,
  ) async {
    try {
      AppPrint.printStep('Removing feature from subscription plan: $planId');

      final currentPlan = await getSubscriptionPlanById(planId);
      if (currentPlan == null) {
        AppPrint.printWarning('Subscription plan not found: $planId');
        return null;
      }

      final updatedFeatures = Map<String, dynamic>.from(currentPlan.features);
      updatedFeatures.remove(featureKey);

      return await updateSubscriptionPlanFeatures(planId, updatedFeatures);
    } catch (e) {
      AppPrint.printError(
        'Failed to remove feature from subscription plan: $e',
      );
      rethrow;
    }
  }

  /// Delete subscription plan
  Future<bool> deleteSubscriptionPlan(String planId) async {
    try {
      AppPrint.printStep('Deleting subscription plan: $planId');
      final startTime = DateTime.now();

      await _supabaseService.deleteData(
        table: _tableName,
        filters: {'plan_id': planId},
      );

      AppPrint.printPerformance(
        'Delete subscription plan',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess('Successfully deleted subscription plan: $planId');

      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete subscription plan: $e');
      rethrow;
    }
  }

  /// Check if subscription plan exists
  Future<bool> subscriptionPlanExists(String planId) async {
    try {
      AppPrint.printStep('Checking if subscription plan exists: $planId');

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: {'plan_id': planId},
      );

      final exists = response.isNotEmpty;
      AppPrint.printInfo('Subscription plan $planId exists: $exists');

      return exists;
    } catch (e) {
      AppPrint.printError('Failed to check if subscription plan exists: $e');
      rethrow;
    }
  }

  /// Get subscription plans with pagination
  Future<List<SubscriptionPlan>> getSubscriptionPlansWithPagination({
    int limit = 10,
    int offset = 0,
    String? billingCycle,
  }) async {
    try {
      AppPrint.printStep(
        'Fetching subscription plans with pagination (limit: $limit, offset: $offset)',
      );
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (billingCycle != null) filters['billing_cycle'] = billingCycle;

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: filters.isNotEmpty ? filters : null,
        limit: limit,
        offset: offset,
      );

      final plans = response
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      AppPrint.printPerformance(
        'Get subscription plans with pagination',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully fetched ${plans.length} subscription plans',
      );

      return plans;
    } catch (e) {
      AppPrint.printError(
        'Failed to fetch subscription plans with pagination: $e',
      );
      rethrow;
    }
  }

  /// Get subscription plans count
  Future<int> getSubscriptionPlansCount({String? billingCycle}) async {
    try {
      AppPrint.printStep('Getting subscription plans count');
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (billingCycle != null) filters['billing_cycle'] = billingCycle;

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: filters.isNotEmpty ? filters : null,
      );

      final count = response.length;

      AppPrint.printPerformance(
        'Get subscription plans count',
        DateTime.now().difference(startTime),
      );
      AppPrint.printInfo('Total subscription plans count: $count');

      return count;
    } catch (e) {
      AppPrint.printError('Failed to get subscription plans count: $e');
      rethrow;
    }
  }

  /// Search subscription plans by name or description
  Future<List<SubscriptionPlan>> searchSubscriptionPlans(
    String searchTerm,
  ) async {
    try {
      AppPrint.printStep('Searching subscription plans: $searchTerm');
      final startTime = DateTime.now();

      final response = await _supabaseService.getData(table: _tableName);

      final plans = response
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      // Filter plans based on search term
      final filteredPlans = plans.where((plan) {
        final searchLower = searchTerm.toLowerCase();
        return plan.name.toLowerCase().contains(searchLower) ||
            (plan.description?.toLowerCase().contains(searchLower) ?? false) ||
            plan.billingCycle.toLowerCase().contains(searchLower);
      }).toList();

      AppPrint.printPerformance(
        'Search subscription plans',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Found ${filteredPlans.length} subscription plans matching: $searchTerm',
      );

      return filteredPlans;
    } catch (e) {
      AppPrint.printError('Failed to search subscription plans: $e');
      rethrow;
    }
  }

  /// Get cheapest subscription plan
  Future<SubscriptionPlan?> getCheapestSubscriptionPlan({
    String? billingCycle,
  }) async {
    try {
      AppPrint.printStep('Fetching cheapest subscription plan');
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (billingCycle != null) filters['billing_cycle'] = billingCycle;

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: filters.isNotEmpty ? filters : null,
      );

      if (response.isEmpty) {
        AppPrint.printWarning('No subscription plans found');
        return null;
      }

      final plans = response
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      // Find the cheapest plan
      final cheapestPlan = plans.reduce((a, b) => a.price < b.price ? a : b);

      AppPrint.printPerformance(
        'Get cheapest subscription plan',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully found cheapest subscription plan: ${cheapestPlan.name}',
      );

      return cheapestPlan;
    } catch (e) {
      AppPrint.printError('Failed to fetch cheapest subscription plan: $e');
      rethrow;
    }
  }

  /// Get most expensive subscription plan
  Future<SubscriptionPlan?> getMostExpensiveSubscriptionPlan({
    String? billingCycle,
  }) async {
    try {
      AppPrint.printStep('Fetching most expensive subscription plan');
      final startTime = DateTime.now();

      final filters = <String, dynamic>{};
      if (billingCycle != null) filters['billing_cycle'] = billingCycle;

      final response = await _supabaseService.getData(
        table: _tableName,
        filters: filters.isNotEmpty ? filters : null,
      );

      if (response.isEmpty) {
        AppPrint.printWarning('No subscription plans found');
        return null;
      }

      final plans = response
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      // Find the most expensive plan
      final mostExpensivePlan = plans.reduce(
        (a, b) => a.price > b.price ? a : b,
      );

      AppPrint.printPerformance(
        'Get most expensive subscription plan',
        DateTime.now().difference(startTime),
      );
      AppPrint.printSuccess(
        'Successfully found most expensive subscription plan: ${mostExpensivePlan.name}',
      );

      return mostExpensivePlan;
    } catch (e) {
      AppPrint.printError(
        'Failed to fetch most expensive subscription plan: $e',
      );
      rethrow;
    }
  }
}
