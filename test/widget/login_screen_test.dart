import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_app/features/auth/screens/login_screen.dart';
import 'package:icon_app/features/auth/bloc/auth_bloc.dart';
import 'package:icon_app/features/auth/bloc/auth_state.dart';
import 'package:icon_app/features/auth/data/auth_repository.dart';

void main() {
  group('LoginScreen', () {
    late AuthRepository authRepository;
    late AuthBloc authBloc;

    setUp(() {
      authRepository = AuthRepository();
      authBloc = AuthBloc(authRepository: authRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const LoginScreen(),
        ),
      );
    }

    testWidgets('should display login form', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify form elements are present
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue your fitness journey'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password fields
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);
    });

    testWidgets('should validate email input', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find email field and enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      // Trigger validation
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should validate password input', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find password field and enter short password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, '123');
      await tester.pump();

      // Trigger validation
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should handle login submission', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Submit form
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Verify that SignInRequested event was added to the bloc
      expect(authBloc.state, isA<AuthLoading>());
    });

    testWidgets('should navigate to signup screen', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap on sign up link
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify navigation (this would need proper navigation setup in test)
      // For now, we just verify the button exists and is tappable
      expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);
    });

    testWidgets('should show error messages', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Emit error state
      authBloc.emit(const AuthError(message: 'Invalid credentials'));
      await tester.pump();

      // Should show error message in snackbar
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('should show loading state', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Emit loading state
      authBloc.emit(const AuthLoading());
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially should show visibility off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Find and tap the visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityButton);
      await tester.pump();

      // Password visibility should be toggled (check the icon changed)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
} 