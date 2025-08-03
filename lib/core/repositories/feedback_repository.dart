import '../models/feedback.dart';
import '../services/supabase_service.dart';
import '../utils/app_print.dart';

/// Repository for managing feedback-related operations
class FeedbackRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Get all feedback
  Future<List<Feedback>> getAllFeedback() async {
    try {
      AppPrint.printInfo('Fetching all feedback...');
      
      final response = await _supabaseService.client
          .from('feedback')
          .select('*, session(*), exercise(*)')
          .order('timestamp', ascending: false);

      final feedbackList = response.map((json) => Feedback.fromJson(json)).toList();
      AppPrint.printInfo('Fetched ${feedbackList.length} feedback items');
      
      return feedbackList;
    } catch (e) {
      AppPrint.printError('Failed to fetch feedback: $e');
      rethrow;
    }
  }

  /// Get feedback by ID
  Future<Feedback?> getFeedbackById(String feedbackId) async {
    try {
      AppPrint.printInfo('Fetching feedback: $feedbackId');
      
      final response = await _supabaseService.client
          .from('feedback')
          .select('*, session(*), exercise(*)')
          .eq('feedback_id', feedbackId)
          .single();

      final feedback = Feedback.fromJson(response);
      AppPrint.printInfo('Fetched feedback: ${feedback.feedbackId}');
      
      return feedback;
    } catch (e) {
      AppPrint.printError('Failed to fetch feedback: $e');
      return null;
    }
  }

  /// Get feedback by session ID
  Future<List<Feedback>> getFeedbackBySessionId(String sessionId) async {
    try {
      AppPrint.printInfo('Fetching feedback for session: $sessionId');
      
      final response = await _supabaseService.client
          .from('feedback')
          .select('*, session(*), exercise(*)')
          .eq('session_id', sessionId)
          .order('timestamp', ascending: false);

      final feedbackList = response.map((json) => Feedback.fromJson(json)).toList();
      AppPrint.printInfo('Fetched ${feedbackList.length} feedback items for session: $sessionId');
      
      return feedbackList;
    } catch (e) {
      AppPrint.printError('Failed to fetch feedback by session: $e');
      rethrow;
    }
  }

  /// Get feedback by type
  Future<List<Feedback>> getFeedbackByType(String feedbackType) async {
    try {
      AppPrint.printInfo('Fetching feedback by type: $feedbackType');
      
      final response = await _supabaseService.client
          .from('feedback')
          .select('*, session(*), exercise(*)')
          .eq('feedback_type', feedbackType)
          .order('timestamp', ascending: false);

      final feedbackList = response.map((json) => Feedback.fromJson(json)).toList();
      AppPrint.printInfo('Fetched ${feedbackList.length} feedback items of type: $feedbackType');
      
      return feedbackList;
    } catch (e) {
      AppPrint.printError('Failed to fetch feedback by type: $e');
      rethrow;
    }
  }

  /// Create new feedback
  Future<Feedback?> createFeedback(Feedback feedback) async {
    try {
      AppPrint.printInfo('Creating feedback...');
      
      final response = await _supabaseService.client
          .from('feedback')
          .insert(feedback.toJson())
          .select('*, session(*), exercise(*)')
          .single();

      final createdFeedback = Feedback.fromJson(response);
      AppPrint.printInfo('Created feedback: ${createdFeedback.feedbackId}');
      
      return createdFeedback;
    } catch (e) {
      AppPrint.printError('Failed to create feedback: $e');
      return null;
    }
  }

  /// Update feedback
  Future<Feedback?> updateFeedback(Feedback feedback) async {
    try {
      AppPrint.printInfo('Updating feedback: ${feedback.feedbackId}');
      
      final response = await _supabaseService.client
          .from('feedback')
          .update(feedback.toJson())
          .eq('feedback_id', feedback.feedbackId)
          .select('*, session(*), exercise(*)')
          .single();

      final updatedFeedback = Feedback.fromJson(response);
      AppPrint.printInfo('Updated feedback: ${updatedFeedback.feedbackId}');
      
      return updatedFeedback;
    } catch (e) {
      AppPrint.printError('Failed to update feedback: $e');
      return null;
    }
  }

  /// Delete feedback
  Future<bool> deleteFeedback(String feedbackId) async {
    try {
      AppPrint.printInfo('Deleting feedback: $feedbackId');
      
      await _supabaseService.client
          .from('feedback')
          .delete()
          .eq('feedback_id', feedbackId);

      AppPrint.printInfo('Deleted feedback: $feedbackId');
      return true;
    } catch (e) {
      AppPrint.printError('Failed to delete feedback: $e');
      return false;
    }
  }

  /// Get feedback statistics
  Future<Map<String, dynamic>> getFeedbackStatistics() async {
    try {
      AppPrint.printInfo('Fetching feedback statistics...');
      
      final allFeedback = await _supabaseService.client
          .from('feedback')
          .select('feedback_id, feedback_type');

      final totalFeedback = allFeedback.length;

      final typeStats = <String, int>{};
      for (final item in allFeedback) {
        final type = item['feedback_type'] as String;
        typeStats[type] = (typeStats[type] ?? 0) + 1;
      }

      final statistics = {
        'total_feedback': totalFeedback,
        'type_stats': typeStats,
      };

      AppPrint.printInfo('Fetched feedback statistics');
      return statistics;
    } catch (e) {
      AppPrint.printError('Failed to fetch feedback statistics: $e');
      rethrow;
    }
  }

  /// Get recent feedback
  Future<List<Feedback>> getRecentFeedback({int limit = 10}) async {
    try {
      AppPrint.printInfo('Fetching recent feedback...');
      
      final response = await _supabaseService.client
          .from('feedback')
          .select('*, session(*), exercise(*)')
          .order('timestamp', ascending: false)
          .limit(limit);

      final feedbackList = response.map((json) => Feedback.fromJson(json)).toList();
      AppPrint.printInfo('Fetched ${feedbackList.length} recent feedback items');
      
      return feedbackList;
    } catch (e) {
      AppPrint.printError('Failed to fetch recent feedback: $e');
      rethrow;
    }
  }
} 