import 'package:dio/dio.dart';
import '../constants/api_config.dart';

/// OpenAI service for AI API interactions
class OpenAIService {
  static OpenAIService? _instance;
  late final Dio _dio;

  OpenAIService._() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.openaiBaseUrl,
      headers: {
        'Authorization': 'Bearer ${ApiConfig.openaiApiKey}',
        'Content-Type': 'application/json',
      },
    ));
  }

  /// Singleton instance of OpenAIService
  static OpenAIService get instance {
    _instance ??= OpenAIService._();
    return _instance!;
  }

  /// Get the Dio client instance
  Dio get client => _dio;

  /// Send a chat completion request to OpenAI
  Future<Map<String, dynamic>> chatCompletion({
    required String message,
    String? systemPrompt,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final messages = <Map<String, String>>[];
      
      if (systemPrompt != null) {
        messages.add({'role': 'system', 'content': systemPrompt});
      }
      
      if (conversationHistory != null) {
        messages.addAll(conversationHistory);
      }
      
      messages.add({'role': 'user', 'content': message});

      final response = await _dio.post('/chat/completions', data: {
        'model': 'gpt-4',
        'messages': messages,
        'max_tokens': 1000,
        'temperature': 0.7,
      });

      return response.data;
    } catch (e) {
      throw Exception('Failed to get chat completion: $e');
    }
  }

  /// Generate workout recommendations
  Future<Map<String, dynamic>> generateWorkoutPlan({
    required String userProfile,
    required String fitnessGoals,
    required String availableTime,
  }) async {
    try {
      final systemPrompt = '''
You are an expert fitness coach. Generate a personalized workout plan based on the user's profile and goals.
Return the response in JSON format with the following structure:
{
  "workout": {
    "title": "Workout Title",
    "description": "Workout description",
    "exercises": [
      {
        "name": "Exercise name",
        "sets": 3,
        "reps": 12,
        "rest_time": 60,
        "description": "Exercise description"
      }
    ]
  }
}
''';

      final message = '''
User Profile: $userProfile
Fitness Goals: $fitnessGoals
Available Time: $availableTime

Please generate a personalized workout plan.
''';

      return await chatCompletion(
        message: message,
        systemPrompt: systemPrompt,
      );
    } catch (e) {
      throw Exception('Failed to generate workout plan: $e');
    }
  }

  /// Generate nutrition advice
  Future<Map<String, dynamic>> generateNutritionAdvice({
    required String userProfile,
    required String fitnessGoals,
    required String dietaryRestrictions,
  }) async {
    try {
      final systemPrompt = '''
You are an expert nutritionist. Provide personalized nutrition advice based on the user's profile and goals.
Return the response in JSON format with the following structure:
{
  "nutrition": {
    "daily_calories": 2000,
    "macros": {
      "protein": "150g",
      "carbs": "200g",
      "fat": "67g"
    },
    "recommendations": [
      "Eat more protein",
      "Stay hydrated"
    ]
  }
}
''';

      final message = '''
User Profile: $userProfile
Fitness Goals: $fitnessGoals
Dietary Restrictions: $dietaryRestrictions

Please provide personalized nutrition advice.
''';

      return await chatCompletion(
        message: message,
        systemPrompt: systemPrompt,
      );
    } catch (e) {
      throw Exception('Failed to generate nutrition advice: $e');
    }
  }

  /// Generate motivational message
  Future<String> generateMotivationalMessage({
    required String userMood,
    required String fitnessGoals,
  }) async {
    try {
      final systemPrompt = '''
You are a motivational fitness coach. Provide encouraging and motivational messages to help users stay on track with their fitness goals.
Keep the message concise, positive, and actionable.
''';

      final message = '''
User Mood: $userMood
Fitness Goals: $fitnessGoals

Please provide a motivational message to help the user stay motivated.
''';

      final response = await chatCompletion(
        message: message,
        systemPrompt: systemPrompt,
      );

      return response['choices'][0]['message']['content'] as String;
    } catch (e) {
      throw Exception('Failed to generate motivational message: $e');
    }
  }
} 