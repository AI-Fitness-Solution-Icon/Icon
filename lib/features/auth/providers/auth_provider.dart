import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../../../core/models/user.dart';

/// Auth provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  /// Get current user
  User? get currentUser => _currentUser;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get error => _error;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authRepository.signInWithEmail(email, password);
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Sign in failed');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authRepository.signUpWithEmail(email, password);
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Sign up failed');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.signOut();
      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.resetPassword(email);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Load current user
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = _authRepository.getCurrentUser();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
    notifyListeners();
  }
} 