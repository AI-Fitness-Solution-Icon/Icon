/// Domain-specific exception for trainer onboarding operations
class TrainerOnboardingException implements Exception {
  final String message;
  final String? code;

  const TrainerOnboardingException(this.message, [this.code]);

  @override
  String toString() {
    if (code != null) {
      return 'TrainerOnboardingException: $message (Code: $code)';
    }
    return 'TrainerOnboardingException: $message';
  }
} 