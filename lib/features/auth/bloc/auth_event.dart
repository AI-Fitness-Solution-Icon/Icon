import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to sign in with email and password
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to sign up with email and password
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to sign out
class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

/// Event to reset password
class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to load current user
class LoadCurrentUserRequested extends AuthEvent {
  const LoadCurrentUserRequested();
}

/// Event to check authentication status
class CheckAuthStatusRequested extends AuthEvent {
  const CheckAuthStatusRequested();
}

/// Event to change password
class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Event to update user profile
class UpdateProfileRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;

  const UpdateProfileRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  List<Object?> get props => [firstName, lastName, email];
}

/// Event to delete user account
class DeleteAccountRequested extends AuthEvent {
  const DeleteAccountRequested();
} 