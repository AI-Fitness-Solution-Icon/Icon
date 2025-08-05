import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  
  await dotenv.load(fileName: ".env");

  // Validate environment variables
  try {
    EnvValidator.validateRequiredEnvVars();
  } catch (e) {
    // Use AppPrint instead of print for production code
    // AppPrint.printError('Environment validation failed: $e');
    // You can choose to exit the app here or show an error screen
    // For now, we'll continue but the app may not work properly
  }

  // Initialize Supabase
  await SupabaseService.initialize();
  // Initialize Stripe
  await StripeService.initialize();
  // Initialize Deep Link Service
  await DeepLinkService().initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SettingsService>(
      future: Future.value(SettingsService()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }
        
        return MultiBlocProvider(
          providers: [
            // Auth Bloc
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                authRepository: AuthRepository(),
              ),
            ),
            // Settings Bloc
            BlocProvider<SettingsBloc>(
              create: (context) => SettingsBloc(snapshot.data!),
            ),
            // Dashboard Bloc
            BlocProvider<DashboardBloc>(
              create: (context) => DashboardBloc(
                dashboardRepository: DashboardRepository(),
              ),
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
      },
    );
  }
}