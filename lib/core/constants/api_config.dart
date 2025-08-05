import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API configuration constants for the Icon app
/// Contains endpoints and configuration for external services
class ApiConfig {
  // Supabase configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'https://rzbzadllidsuexaspxyz.supabase.co';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  // OpenAI configuration
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static String get openaiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  
  // Stripe configuration
  static String get stripePublishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String get stripeSecretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  
  // Voice synthesis API configuration
  static const String voiceApiUrl = 'https://api.voice-synthesis.com';
  static String get voiceApiKey => dotenv.env['VOICE_API_KEY'] ?? '';
  
  // App configuration
  static const String appName = 'Icon';
  static const String appVersion = '1.0.0';
  
  // API endpoints
  static const String authEndpoint = '/auth';
  static const String workoutEndpoint = '/workouts';
  static const String aiCoachEndpoint = '/ai-coach';
  static const String subscriptionEndpoint = '/subscriptions';
} 