import 'package:logger/logger.dart';
import '../../core/services/supabase_service.dart';

/// Service for handling feedback submission
class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final Logger _logger = Logger();
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Submit feedback to the API
  Future<bool> submitFeedback({
    required String type,
    required String subject,
    required String message,
    String? email,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userId = _supabaseService.currentUser?.id;
      
      final feedbackData = {
        'user_id': userId,
        'type': type,
        'subject': subject,
        'message': message,
        'email': email,
        'metadata': metadata ?? {},
        'created_at': DateTime.now().toIso8601String(),
        'status': 'pending',
      };

      // Insert feedback into Supabase
      final response = await _supabaseService.client
          .from('feedback')
          .insert(feedbackData)
          .select()
          .single();

      _logger.i('Feedback submitted successfully: ${response['id']}');
      
      // Send notification to admin (optional)
      await _sendAdminNotification(feedbackData);
      
      return true;
    } catch (e) {
      _logger.e('Failed to submit feedback: $e');
      return false;
    }
  }

  /// Send admin notification about new feedback
  Future<void> _sendAdminNotification(Map<String, dynamic> feedbackData) async {
    try {
      // This could be implemented with a webhook or email service
      _logger.i('Admin notification sent for feedback: ${feedbackData['id']}');
    } catch (e) {
      _logger.e('Failed to send admin notification: $e');
    }
  }

  /// Get user's feedback history
  Future<List<Map<String, dynamic>>> getUserFeedbackHistory() async {
    try {
      final userId = _supabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabaseService.client
          .from('feedback')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      _logger.e('Failed to get feedback history: $e');
      return [];
    }
  }

  /// Get feedback by ID
  Future<Map<String, dynamic>?> getFeedbackById(String feedbackId) async {
    try {
      final response = await _supabaseService.client
          .from('feedback')
          .select()
          .eq('id', feedbackId)
          .single();

      return response;
    } catch (e) {
      _logger.e('Failed to get feedback by ID: $e');
      return null;
    }
  }

  /// Update feedback status
  Future<bool> updateFeedbackStatus({
    required String feedbackId,
    required String status,
    String? adminResponse,
  }) async {
    try {
      final updateData = {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (adminResponse != null) {
        updateData['admin_response'] = adminResponse;
      }

      await _supabaseService.client
          .from('feedback')
          .update(updateData)
          .eq('id', feedbackId);

      _logger.i('Feedback status updated: $feedbackId -> $status');
      return true;
    } catch (e) {
      _logger.e('Failed to update feedback status: $e');
      return false;
    }
  }

  /// Delete feedback
  Future<bool> deleteFeedback(String feedbackId) async {
    try {
      await _supabaseService.client
          .from('feedback')
          .delete()
          .eq('id', feedbackId);

      _logger.i('Feedback deleted: $feedbackId');
      return true;
    } catch (e) {
      _logger.e('Failed to delete feedback: $e');
      return false;
    }
  }
} 