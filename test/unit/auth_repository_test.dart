import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:icon_app/features/auth/data/auth_repository.dart';
import 'package:icon_app/core/services/supabase_service.dart';
import 'package:icon_app/core/repositories/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'auth_repository_test.mocks.dart';

@GenerateMocks([SupabaseClient, GoTrueClient, SupabaseService, User, UserRepository])
void main() {
  late AuthRepository authRepository;
  late MockSupabaseService mockSupabaseService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockSupabaseService = MockSupabaseService();
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    mockUserRepository = MockUserRepository();
    
    // Mock the Supabase.instance.client getter
    // This is a bit of a workaround since we can't directly mock the static instance.
    // We will mock the service that uses it.
    when(mockSupabaseService.client).thenReturn(mockSupabaseClient);
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);

    authRepository = AuthRepository();
  });

  group('AuthRepository', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';
    final tUser = User(id: '1', appMetadata: {}, userMetadata: {}, aud: 'authenticated', createdAt: DateTime.now().toIso8601String());

    test('signInWithEmail returns a user on successful sign in', () async {
      final authResponse = AuthResponse(user: tUser, session: Session(accessToken: 'token', tokenType: 'bearer', user: tUser));
      when(mockGoTrueClient.signInWithPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => authResponse);

      final result = await authRepository.signInWithEmail(tEmail, tPassword);

      expect(result, equals(tUser));
      verify(mockGoTrueClient.signInWithPassword(email: tEmail, password: tPassword)).called(1);
    });

    test('signInWithEmail throws an exception on failure', () async {
      when(mockGoTrueClient.signInWithPassword(email: tEmail, password: tPassword))
          .thenThrow(const AuthException('Invalid login credentials'));

      expect(() => authRepository.signInWithEmail(tEmail, tPassword), throwsA(isA<AuthException>()));
    });

    test('signUpWithEmail returns user and requires email confirmation', () async {
      final authResponse = AuthResponse(user: tUser, session: null);
      when(mockGoTrueClient.signUp(email: tEmail, password: tPassword, emailRedirectTo: "icon://login-callback"))
          .thenAnswer((_) async => authResponse);

      final result = await authRepository.signUpWithEmail(tEmail, tPassword);

      expect(result['user'], tUser);
      expect(result['requiresEmailConfirmation'], isTrue);
    });

    test('signOut completes successfully', () async {
      when(mockGoTrueClient.signOut()).thenAnswer((_) async => AuthResponse(session: null, user: null));
      await authRepository.signOut();
      verify(mockGoTrueClient.signOut()).called(1);
    });

    test('isAuthenticated returns true when user is authenticated', () {
      when(mockSupabaseService.isAuthenticated).thenReturn(true);
      final result = authRepository.isAuthenticated();
      expect(result, isTrue);
    });

    test('resetPassword completes successfully', () async {
      when(mockSupabaseService.resetPassword(tEmail)).thenAnswer((_) async => {});
      await authRepository.resetPassword(tEmail);
      verify(mockSupabaseService.resetPassword(tEmail)).called(1);
    });

    test('deleteAccount completes successfully', () async {
      when(mockSupabaseService.currentUser).thenReturn(tUser);
      when(mockUserRepository.deleteUser(tUser.id)).thenAnswer((_) async => Future.value());
      when(mockSupabaseService.deleteUser()).thenAnswer((_) async => {});

      await authRepository.deleteAccount();

      verify(mockUserRepository.deleteUser(tUser.id)).called(1);
      verify(mockSupabaseService.deleteUser()).called(1);
    });
  });
}