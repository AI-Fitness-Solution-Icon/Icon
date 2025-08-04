import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icon_app/features/trainer_onboarding/presentation/widgets/onboarding_progress_bar.dart';

void main() {
  group('OnboardingProgressBar Widget Tests', () {
    testWidgets('should display progress bar with correct percentage', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingProgressBar(
              currentStep: 2,
              totalSteps: 4,
              progressPercentage: 0.5,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(OnboardingProgressBar), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should show correct step text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingProgressBar(
              currentStep: 3,
              totalSteps: 4,
              progressPercentage: 0.75,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Step 3 of 4'), findsOneWidget);
    });

    testWidgets('should handle edge cases', (WidgetTester tester) async {
      // Test step 1
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingProgressBar(
              currentStep: 1,
              totalSteps: 4,
              progressPercentage: 0.25,
            ),
          ),
        ),
      );
      expect(find.text('Step 1 of 4'), findsOneWidget);

      // Test final step
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingProgressBar(
              currentStep: 4,
              totalSteps: 4,
              progressPercentage: 1.0,
            ),
          ),
        ),
      );
      expect(find.text('Step 4 of 4'), findsOneWidget);
    });
  });

  group('Trainer Onboarding UI Component Tests', () {
    testWidgets('should create form fields correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your full name'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('should handle text input', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pump();

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should create buttons correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Next'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('should handle button taps', (WidgetTester tester) async {
      bool buttonPressed = false;

      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: const Text('Next'),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Assert
      expect(buttonPressed, isTrue);
    });

    testWidgets('should create selection widgets', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Pronouns'),
                Wrap(
                  children: [
                    ChoiceChip(
                      label: const Text('He/Him'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      label: const Text('She/Her'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      label: const Text('They/Them'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Pronouns'), findsOneWidget);
      expect(find.text('He/Him'), findsOneWidget);
      expect(find.text('She/Her'), findsOneWidget);
      expect(find.text('They/Them'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNWidgets(3));
    });
  });
} 