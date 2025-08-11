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
  Future<void> submitFeedback({
    required String message,
    required String category,
    required int rating,
  }) async {
    try {
      final userId = _supabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabaseService.insertData(
        table: 'feedback',
        data: {
          'id': userId,
          'message': message,
          'category': category,
          'rating': rating,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      _logger.i('Feedback submitted successfully');
    } catch (e) {
      _logger.e('Failed to submit feedback: $e');
      rethrow;
    }
  }

  /// Get user's feedback history
  Future<List<Map<String, dynamic>>> getUserFeedback() async {
    try {
      final userId = _supabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final feedback = await _supabaseService.getData(
        table: 'feedback',
        filters: {'id': userId},
      );

      return feedback;
    } catch (e) {
      _logger.e('Failed to get user feedback: $e');
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
