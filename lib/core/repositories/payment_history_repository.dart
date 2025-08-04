import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_history.dart';
import '../constants/api_config.dart';
import '../utils/app_print.dart';
import '../services/supabase_service.dart';

/// Repository for handling payment history operations
class PaymentHistoryRepository {
  static final PaymentHistoryRepository _instance = PaymentHistoryRepository._internal();
  factory PaymentHistoryRepository() => _instance;
  PaymentHistoryRepository._internal();

  // Using Supabase URL as base for now, can be changed when backend is ready
  final String _baseUrl = ApiConfig.supabaseUrl;
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Get authentication headers
  Map<String, String> _getAuthHeaders() {
    final session = _supabaseService.currentSession;
    final token = session?.accessToken;
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get payment history for the current user
  Future<List<PaymentHistory>> getPaymentHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/payment-history'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaymentHistory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment history: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Error fetching payment history: $e');
      // For now, return mock data if API fails
      return _getMockPaymentHistory();
    }
  }

  /// Download payment statement as PDF
  Future<String> downloadStatement({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payment-history/download'),
        headers: _getAuthHeaders(),
        body: json.encode({
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['download_url'] as String;
      } else {
        throw Exception('Failed to generate statement: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Error downloading statement: $e');
      throw Exception('Failed to download statement: $e');
    }
  }

  /// Get payment history summary
  Future<Map<String, dynamic>> getPaymentSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/payment-history/summary'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load payment summary: ${response.statusCode}');
      }
    } catch (e) {
      AppPrint.printError('Error fetching payment summary: $e');
      // Return mock summary if API fails
      return _getMockPaymentSummary();
    }
  }

  /// Mock payment history data for development
  List<PaymentHistory> _getMockPaymentHistory() {
    return [
      PaymentHistory(
        paymentId: '1',
        subscriptionId: 'sub_1',
        amount: 29.99,
        currency: 'USD',
        paymentDate: DateTime.now().subtract(const Duration(days: 1)),
        stripeInvoiceId: 'in_1234567890',
        status: 'completed',
      ),
      PaymentHistory(
        paymentId: '2',
        subscriptionId: 'sub_1',
        amount: 29.99,
        currency: 'USD',
        paymentDate: DateTime.now().subtract(const Duration(days: 32)),
        stripeInvoiceId: 'in_1234567891',
        status: 'completed',
      ),
      PaymentHistory(
        paymentId: '3',
        subscriptionId: 'sub_1',
        amount: 29.99,
        currency: 'USD',
        paymentDate: DateTime.now().subtract(const Duration(days: 63)),
        stripeInvoiceId: 'in_1234567892',
        status: 'completed',
      ),
      PaymentHistory(
        paymentId: '4',
        subscriptionId: 'sub_1',
        amount: 29.99,
        currency: 'USD',
        paymentDate: DateTime.now().subtract(const Duration(days: 94)),
        stripeInvoiceId: 'in_1234567893',
        status: 'failed',
      ),
    ];
  }

  /// Mock payment summary data for development
  Map<String, dynamic> _getMockPaymentSummary() {
    return {
      'total_amount': 89.97,
      'total_transactions': 4,
      'successful_transactions': 3,
      'failed_transactions': 1,
      'currency': 'USD',
    };
  }
} 