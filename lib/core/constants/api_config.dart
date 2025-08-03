import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API configuration constants for the Icon app
/// Contains endpoints and configuration for external services
class ApiConfig {
  // Supabase configuration
  static const String supabaseUrl = 'https://rzbzadllidsuexaspxyz.supabase.co';
  static String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  // OpenAI configuration
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String openaiApiKey = 'your-openai-api-key';
  
  // Stripe configuration
  static const String stripePublishableKey = 'your-stripe-publishable-key';
  static const String stripeSecretKey = 'your-stripe-secret-key';
  
  // Voice synthesis API configuration
  static const String voiceApiUrl = 'https://api.voice-synthesis.com';
  static const String voiceApiKey = 'your-voice-api-key';
  
  // App configuration
  static const String appName = 'Icon';
  static const String appVersion = '1.0.0';
  
  // API endpoints
  static const String authEndpoint = '/auth';
  static const String workoutEndpoint = '/workouts';
  static const String aiCoachEndpoint = '/ai-coach';
  static const String subscriptionEndpoint = '/subscriptions';
} 