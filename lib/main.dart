import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:icon_app/core/repositories/fitness_goals_repository.dart';
import 'package:icon_app/features/onboarding/bloc/onboarding_bloc_impl.dart';
import 'core/constants/app_themes.dart';
import 'core/constants/app_strings.dart';
import 'core/services/supabase_service.dart';
import 'core/services/stripe_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/deep_link_service.dart';
import 'core/utils/env_validator.dart';
import 'navigation/app_router.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/settings/bloc/settings_bloc.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/data/dashboard_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Validate environment variables
    try {
      EnvValidator.validateRequiredEnvVars();
    } catch (e) {
      debugPrint('Environment validation failed: $e');
      // Continue but the app may not work properly
    }

    // Initialize services in order
    await SupabaseService.initialize();
    await StripeService.initialize();
    await DeepLinkService().initialize();
    await SettingsService().initialize();

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Failed to initialize app: $e');
    // Show error screen
    runApp(const ErrorApp());
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize app',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Please restart the app or check your configuration.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Bloc
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        // Settings Bloc
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(SettingsService()),
        ),
        // Dashboard Bloc
        BlocProvider<DashboardBloc>(
          create: (context) =>
              DashboardBloc(dashboardRepository: DashboardRepository()),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) =>
              OnboardingBloc(fitnessGoalsRepository: FitnessGoalsRepository()),
        ),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppThemes.darkTheme, // Use dark theme as default
        darkTheme: AppThemes.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
