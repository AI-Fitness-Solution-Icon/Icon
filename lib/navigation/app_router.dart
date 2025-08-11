import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_app/features/splash/screens/splash_screen.dart';
import 'package:icon_app/features/onboarding/screens/user_type_selection_screen.dart';
import 'package:icon_app/features/trainer_onboarding/presentation/screens/trainer_onboarding_screen.dart';
import 'package:icon_app/features/onboarding/screens/personal_info_screen.dart';
import 'package:icon_app/features/onboarding/screens/fitness_goals_screen.dart'
    as onboarding;
import 'package:icon_app/features/onboarding/screens/training_location_screen.dart';
import 'package:icon_app/features/onboarding/screens/training_routine_screen.dart';
import 'package:icon_app/features/onboarding/screens/nutrition_goals_screen.dart';
import 'package:icon_app/features/auth/screens/login_screen.dart';
import 'package:icon_app/features/auth/screens/signup_screen.dart';
import 'package:icon_app/features/auth/screens/email_verification_screen.dart';
import 'package:icon_app/features/auth/screens/forgot_password_screen.dart';
import 'package:icon_app/features/auth/screens/reset_password_screen.dart';
import 'package:icon_app/features/auth/screens/profile_screen.dart';
import 'package:icon_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:icon_app/features/auth/screens/edit_profile_screen.dart';
import 'package:icon_app/features/auth/screens/change_password_screen.dart';
import 'package:icon_app/features/workout/screens/workout_home.dart';
import 'package:icon_app/features/workout/screens/workout_session.dart';
import 'package:icon_app/features/ai_coach/screens/ai_chat_screen.dart';
import 'package:icon_app/features/ai_coach/screens/voice_interaction.dart';
import 'package:icon_app/features/subscription/screens/subscription_screen.dart';
import 'package:icon_app/features/settings/screens/settings_screen.dart';
import 'package:icon_app/features/settings/screens/notification_settings_screen.dart';
import 'package:icon_app/features/settings/screens/privacy_settings_screen.dart';
import 'package:icon_app/features/settings/screens/fitness_goals_screen.dart';
import 'package:icon_app/features/settings/screens/payment_history_screen.dart';
import 'package:icon_app/features/settings/screens/help_screen.dart';
import 'package:icon_app/features/settings/screens/feedback_screen.dart';
import 'package:icon_app/features/settings/screens/webview_screen.dart';
import 'package:icon_app/features/community/screens/community_screen.dart';
import 'package:icon_app/features/workout/screens/strength_workouts_screen.dart';
import 'package:icon_app/features/workout/screens/create_workout_screen.dart';
import 'package:icon_app/core/services/supabase_service.dart';
import 'package:icon_app/navigation/route_names.dart';

/// App router configuration using go_router
class AppRouter {
  /// Main router instance
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      // Splash and onboarding routes
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.userTypeSelectionPath,
        name: RouteNames.userTypeSelection,
        builder: (context, state) => const UserTypeSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.trainerOnboardingPath,
        name: RouteNames.trainerOnboarding,
        builder: (context, state) => const TrainerOnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.personalInfoPath,
        name: RouteNames.personalInfo,
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: RouteNames.fitnessGoalsPath,
        name: RouteNames.fitnessGoals,
        builder: (context, state) => const onboarding.FitnessGoalsScreen(),
      ),
      GoRoute(
        path: RouteNames.trainingLocationPath,
        name: RouteNames.trainingLocation,
        builder: (context, state) => const TrainingLocationScreen(),
      ),
      GoRoute(
        path: RouteNames.trainingRoutinePath,
        name: RouteNames.trainingRoutine,
        builder: (context, state) => const TrainingRoutineScreen(),
      ),
      GoRoute(
        path: RouteNames.nutritionGoalsPath,
        name: RouteNames.nutritionGoals,
        builder: (context, state) => const NutritionGoalsScreen(),
      ),

      // Auth routes
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signupPath,
        name: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordPath,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.resetPasswordPath,
        name: RouteNames.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.emailVerificationPath,
        name: RouteNames.emailVerification,
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: RouteNames.profilePath,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfilePath,
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.changePasswordPath,
        name: RouteNames.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),

      // Workout routes
      GoRoute(
        path: RouteNames.workoutPath,
        name: RouteNames.workout,
        builder: (context, state) => const WorkoutHomeScreen(),
        routes: [
          GoRoute(
            path: 'session/:id',
            name: RouteNames.workoutSession,
            builder: (context, state) {
              final workoutId = state.pathParameters['id'] ?? '';
              return WorkoutSession(workoutId: workoutId);
            },
          ),
        ],
      ),

      // Strength workouts route
      GoRoute(
        path: RouteNames.strengthWorkoutsPath,
        name: RouteNames.strengthWorkouts,
        builder: (context, state) => const StrengthWorkoutsScreen(),
      ),

      // Create workout route
      GoRoute(
        path: RouteNames.createWorkoutPath,
        name: RouteNames.createWorkout,
        builder: (context, state) => const CreateWorkoutScreen(),
      ),

      // Community route
      GoRoute(
        path: RouteNames.communityPath,
        name: RouteNames.community,
        builder: (context, state) => const CommunityScreen(),
      ),

      // AI Coach routes
      GoRoute(
        path: RouteNames.aiCoachPath,
        name: RouteNames.aiCoach,
        builder: (context, state) => const AiChatScreen(),
        routes: [
          GoRoute(
            path: 'voice',
            name: RouteNames.voiceInteraction,
            builder: (context, state) => const VoiceInteraction(),
          ),
        ],
      ),

      // Subscription routes
      GoRoute(
        path: RouteNames.subscriptionPath,
        name: RouteNames.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),

      // Settings routes
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.notificationSettingsPath,
        name: RouteNames.notificationSettings,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.privacySettingsPath,
        name: RouteNames.privacySettings,
        builder: (context, state) => const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.fitnessGoalsSettingsPath,
        name: RouteNames.fitnessGoalsSettings,
        builder: (context, state) => const FitnessGoalsScreen(),
      ),
      GoRoute(
        path: RouteNames.paymentHistoryPath,
        name: RouteNames.paymentHistory,
        builder: (context, state) => const PaymentHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.helpPath,
        name: RouteNames.help,
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: RouteNames.feedbackPath,
        name: RouteNames.feedback,
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: RouteNames.webviewPath,
        name: RouteNames.webview,
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? '';
          final url = state.uri.queryParameters['url'] ?? '';
          return WebViewScreen(title: title, url: url);
        },
      ),

      // Dashboard route
      GoRoute(
        path: RouteNames.dashboardPath,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),

      // Root route - redirect to dashboard
      GoRoute(
        path: RouteNames.homePath,
        name: RouteNames.home,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],

    // Redirect logic for authentication
    redirect: (context, state) {
      final supabaseService = SupabaseService.instance;
      final isAuthenticated = supabaseService.isAuthenticated;
      final isAuthRoute =
          state.matchedLocation == RouteNames.loginPath ||
          state.matchedLocation == RouteNames.signupPath;
      final isOnboardingRoute =
          state.matchedLocation == RouteNames.splashPath ||
          state.matchedLocation == RouteNames.userTypeSelectionPath;

      // Allow access to splash and onboarding routes
      if (isOnboardingRoute) {
        return null;
      }

      // If user is not authenticated and trying to access protected routes
      if (!isAuthenticated && !isAuthRoute) {
        return RouteNames.userTypeSelectionPath;
      }

      // If user is authenticated and trying to access auth routes
      if (isAuthenticated && isAuthRoute) {
        return RouteNames.homePath;
      }

      // Allow access to the requested route
      return null;
    },

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.homePath),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Navigation helper methods
class NavigationHelper {
  /// Navigate to splash screen
  static void goToSplash(BuildContext context) {
    context.go(RouteNames.splashPath);
  }

  /// Navigate to user type selection screen
  static void goToUserTypeSelection(BuildContext context) {
    context.go(RouteNames.userTypeSelectionPath);
  }

  /// Navigate to login screen
  static void goToLogin(BuildContext context) {
    context.go(RouteNames.loginPath);
  }

  /// Navigate to signup screen
  static void goToSignup(BuildContext context) {
    context.go(RouteNames.signupPath);
  }

  /// Navigate to profile screen
  static void goToProfile(BuildContext context) {
    context.go(RouteNames.profilePath);
  }

  /// Navigate to edit profile screen
  static void goToEditProfile(BuildContext context) {
    context.go(RouteNames.editProfilePath);
  }

  /// Navigate to change password screen
  static void goToChangePassword(BuildContext context) {
    context.go(RouteNames.changePasswordPath);
  }

  /// Navigate to notification settings screen
  static void goToNotificationSettings(BuildContext context) {
    context.go(RouteNames.notificationSettingsPath);
  }

  /// Navigate to privacy settings screen
  static void goToPrivacySettings(BuildContext context) {
    context.go(RouteNames.privacySettingsPath);
  }

  /// Navigate to workout home
  static void goToWorkoutHome(BuildContext context) {
    context.go(RouteNames.workoutPath);
  }

  /// Navigate to workout session
  static void goToWorkoutSession(BuildContext context, String workoutId) {
    context.go('${RouteNames.workoutSessionPath}/$workoutId');
  }

  /// Navigate to AI chat screen
  static void goToAIChat(BuildContext context) {
    context.go(RouteNames.aiCoachPath);
  }

  /// Navigate to voice interaction
  static void goToVoiceInteraction(BuildContext context) {
    context.go(RouteNames.voiceInteractionPath);
  }

  /// Navigate to subscription screen
  static void goToSubscription(BuildContext context) {
    context.go(RouteNames.subscriptionPath);
  }

  /// Navigate to settings screen
  static void goToSettings(BuildContext context) {
    context.go(RouteNames.settingsPath);
  }

  /// Navigate to home
  static void goToHome(BuildContext context) {
    context.go(RouteNames.homePath);
  }

  /// Go back
  static void goBack(BuildContext context) {
    context.pop();
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }
}
