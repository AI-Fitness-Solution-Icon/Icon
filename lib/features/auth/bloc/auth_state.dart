import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication is in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class Authenticated extends AuthState {
  final supabase.User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// State when authentication fails
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when password reset is successful
class PasswordResetSent extends AuthState {
  const PasswordResetSent();
}

/// State when sign up is successful but email verification is needed
class SignUpSuccess extends AuthState {
  const SignUpSuccess();
}

/// State when password change is successful
class PasswordChanged extends AuthState {
  const PasswordChanged();
}

/// State when account deletion is successful
class AccountDeleted extends AuthState {
  const AccountDeleted();
} 