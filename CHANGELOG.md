# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Enhanced trainer onboarding system with improved validation and error handling
- Added trainer_profiles table to database schema with proper RLS policies
- Implemented comprehensive password strength validation (uppercase, lowercase, number, special character)
- Added email availability checking with loading states and user-friendly error messages
- Enhanced error handling with specific error messages for different failure scenarios
- Added loading states for email validation and account creation processes

### Fixed
- Fixed all linter errors and warnings in the codebase
- Resolved undefined class 'SpeechRecognitionResult' in speech_to_text_service.dart
- Fixed BLoC class name mismatches in voice_interaction_screen.dart (AICoachBloc → AiCoachBloc)
- Corrected SendMessageEvent constructor usage
- Removed unused imports and variables across multiple files
- Fixed deprecated API usage in speech recognition service
- Resolved unused field warnings and made appropriate fields final
- Fixed type test errors with undefined state classes
- Fixed email validation to properly check Supabase auth.users table
- Improved repository error handling with specific error messages
- Fixed compilation errors in trainer onboarding BLoC after Provider to BLoC migration
- Resolved emit method usage issues in BLoC event handlers
- Fixed type safety issues in training philosophy screen
- Corrected BLoC state access patterns in UI components

### Changed
- Updated speech recognition service to use proper dynamic typing for result handling
- Improved voice interaction screen to properly handle AI coach responses
- Cleaned up unused code and imports for better code quality
- Migrated trainer onboarding from Provider to BLoC pattern for consistency with app architecture
- Enhanced trainer onboarding BLoC with additional loading states and validation methods
- Updated database schema to include trainer_profiles table with proper structure

## [0.1.0] - 2024-01-01

### Added
- Initial project setup
- Basic Flutter app structure
- Core services and utilities 