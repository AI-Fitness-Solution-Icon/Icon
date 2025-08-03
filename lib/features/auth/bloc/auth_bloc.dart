import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import '../../../core/models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LoadCurrentUserRequested>(_onLoadCurrentUserRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  /// Handle sign in request
  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.signInWithEmail(
        event.email,
        event.password,
      );

      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const AuthError(message: 'Sign in failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handle sign up request
  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.signUpWithEmail(
        event.email,
        event.password,
      );

      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const AuthError(message: 'Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handle sign out request
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handle password reset request
  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.resetPassword(event.email);
      emit(const PasswordResetSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handle load current user request
  Future<void> _onLoadCurrentUserRequested(
    LoadCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handle check authentication status request
  Future<void> _onCheckAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (_authRepository.isAuthenticated()) {
        final user = _authRepository.getCurrentUser();
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handle delete account request
  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.deleteAccount();
      emit(const AccountDeleted());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Get current user from state
  User? get currentUser {
    if (state is Authenticated) {
      return (state as Authenticated).user;
    }
    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state is Authenticated;

  /// Check if authentication is loading
  bool get isLoading => state is AuthLoading;

  /// Handle change password request
  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.changePassword(
        event.currentPassword,
        event.newPassword,
      );
      emit(const PasswordChanged());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handle profile update request
  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final updatedUser = await _authRepository.updateProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
      );
      
      if (updatedUser != null) {
        emit(Authenticated(user: updatedUser));
      } else {
        emit(const AuthError(message: 'Profile update failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
} 