import 'package:flutter_test/flutter_test.dart';
import 'package:icon_app/features/trainer_onboarding/domain/entities/trainer_profile.dart';

void main() {
  group('TrainerProfile Entity Tests', () {
    test('should create a valid trainer profile', () {
      // Arrange & Act
      final profile = TrainerProfile(
        id: 'test-id',
        fullName: 'John Doe',
        pronouns: 'He/Him',
        customPronouns: null,
        nickname: 'Johnny',
        experienceLevel: '3-5 years',
        descriptiveWords: ['Motivated', 'Patient', 'Knowledgeable'],
        motivation: 'I want to help people achieve their fitness goals',
        certifications: ['NASM', 'ACE'],
        coachingExperience: '5 years of personal training experience',
        equipmentDetails: 'Full gym equipment available',
        trainingPhilosophy: ['Progressive Overload', 'Form First'],
      );

      // Assert
      expect(profile.id, equals('test-id'));
      expect(profile.fullName, equals('John Doe'));
      expect(profile.pronouns, equals('He/Him'));
      expect(profile.descriptiveWords, hasLength(3));
      expect(profile.certifications, hasLength(2));
      expect(profile.trainingPhilosophy, hasLength(2));
    });

    test('should handle empty lists for optional fields', () {
      // Arrange & Act
      final profile = TrainerProfile(
        id: 'test-id',
        fullName: 'Jane Smith',
        pronouns: 'She/Her',
        experienceLevel: '1-3 years',
        descriptiveWords: [],
        certifications: [],
        trainingPhilosophy: [],
      );

      // Assert
      expect(profile.descriptiveWords, isEmpty);
      expect(profile.certifications, isEmpty);
      expect(profile.trainingPhilosophy, isEmpty);
    });

    test('should calculate current step correctly', () {
      // Test step 1 - only basic info
      final step1Profile = TrainerProfile(
        fullName: 'John Doe',
        experienceLevel: '3-5 years',
        descriptiveWords: ['Motivated'],
        motivation: 'I want to help people',
      );
      expect(step1Profile.currentStep, equals(1));

      // Test step 2 - with credentials
      final step2Profile = step1Profile.copyWith(
        certifications: ['NASM'],
        coachingExperience: '5 years experience',
      );
      expect(step2Profile.currentStep, equals(2));

      // Test step 3 - with philosophy
      final step3Profile = step2Profile.copyWith(
        trainingPhilosophy: ['Progressive Overload'],
      );
      expect(step3Profile.currentStep, equals(3));

      // Test step 4 - with account info
      final step4Profile = step3Profile.copyWith(
        email: 'john@example.com',
        password: 'password123',
      );
      expect(step4Profile.currentStep, equals(4));
    });

    test('should check if profile is complete for account creation', () {
      // Incomplete profile
      final incompleteProfile = TrainerProfile(
        fullName: 'John Doe',
        email: 'john@example.com',
        // Missing password
      );
      expect(incompleteProfile.isCompleteForAccountCreation, isFalse);

      // Complete profile
      final completeProfile = TrainerProfile(
        fullName: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
      );
      expect(completeProfile.isCompleteForAccountCreation, isTrue);
    });

    test('should create copy with updated fields', () {
      // Arrange
      final originalProfile = TrainerProfile(
        id: 'test-id',
        fullName: 'John Doe',
        pronouns: 'He/Him',
        experienceLevel: '3-5 years',
        descriptiveWords: ['Motivated'],
        certifications: ['NASM'],
        trainingPhilosophy: ['Progressive Overload'],
      );

      // Act
      final updatedProfile = originalProfile.copyWith(
        fullName: 'John Smith',
        descriptiveWords: ['Motivated', 'Patient'],
        certifications: ['NASM', 'ACE'],
      );

      // Assert
      expect(updatedProfile.id, equals(originalProfile.id));
      expect(updatedProfile.fullName, equals('John Smith'));
      expect(updatedProfile.pronouns, equals(originalProfile.pronouns));
      expect(updatedProfile.descriptiveWords, hasLength(2));
      expect(updatedProfile.certifications, hasLength(2));
      expect(updatedProfile.trainingPhilosophy, equals(originalProfile.trainingPhilosophy));
    });

    test('should have correct total steps constant', () {
      expect(TrainerProfile.totalSteps, equals(4));
    });

    test('should implement equality correctly', () {
      final profile1 = TrainerProfile(
        id: 'test-id',
        fullName: 'John Doe',
        pronouns: 'He/Him',
        experienceLevel: '3-5 years',
        descriptiveWords: ['Motivated'],
        certifications: ['NASM'],
        trainingPhilosophy: ['Progressive Overload'],
      );

      final profile2 = TrainerProfile(
        id: 'test-id',
        fullName: 'John Doe',
        pronouns: 'He/Him',
        experienceLevel: '3-5 years',
        descriptiveWords: ['Motivated'],
        certifications: ['NASM'],
        trainingPhilosophy: ['Progressive Overload'],
      );

      final profile3 = TrainerProfile(
        id: 'different-id',
        fullName: 'John Doe',
        pronouns: 'He/Him',
        experienceLevel: '3-5 years',
        descriptiveWords: ['Motivated'],
        certifications: ['NASM'],
        trainingPhilosophy: ['Progressive Overload'],
      );

      expect(profile1, equals(profile2));
      expect(profile1, isNot(equals(profile3)));
      expect(profile1.hashCode, equals(profile2.hashCode));
    });
  });
} 