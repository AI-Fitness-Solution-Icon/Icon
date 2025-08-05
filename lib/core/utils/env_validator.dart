import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility class to validate environment variables
class EnvValidator {
  /// Validate that all required environment variables are set
  static void validateRequiredEnvVars() {
    final requiredVars = [
      'SUPABASE_URL',
      'SUPABASE_ANON_KEY',
      'OPENAI_API_KEY',
      'STRIPE_PUBLISHABLE_KEY',
      'STRIPE_SECRET_KEY',
    ];

    final missingVars = <String>[];
    
    for (final varName in requiredVars) {
      final value = dotenv.env[varName];
      if (value == null || value.isEmpty || value.contains('your-')) {
        missingVars.add(varName);
      }
    }

    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing or invalid environment variables: ${missingVars.join(', ')}\n'
        'Please check your .env file and ensure all required variables are set with valid values.'
      );
    }
  }

  /// Check if a specific environment variable is set
  static bool isEnvVarSet(String varName) {
    final value = dotenv.env[varName];
    return value != null && value.isNotEmpty && !value.contains('your-');
  }

  /// Get environment variable value with validation
  static String getEnvVar(String varName, {String? defaultValue}) {
    final value = dotenv.env[varName];
    if (value == null || value.isEmpty || value.contains('your-')) {
      if (defaultValue != null) {
        return defaultValue;
      }
      throw Exception('Environment variable $varName is not set or invalid');
    }
    return value;
  }
} 