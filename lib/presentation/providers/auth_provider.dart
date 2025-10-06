import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

part 'auth_provider.g.dart';

// Auth State
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  final String? message;
  const AuthUnauthenticated({this.message});
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// Auth State Notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthInitial();
  }

  Future<void> _checkAuthStatus() async {
    state = const AuthLoading();
    
    final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
    final result = await getCurrentUserUseCase();
    
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = user != null 
          ? AuthAuthenticated(user) 
          : const AuthUnauthenticated(),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    
    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(LoginParams(
      email: email.trim(),
      password: password,
    ));
    
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase();
    
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthUnauthenticated(message: 'Logged out successfully'),
    );
  }

  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }
}

// Auth State Provider
@riverpod
AuthState authState(AuthStateRef ref) {
  return ref.watch(authNotifierProvider);
}

// Current User Provider
@riverpod
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthAuthenticated ? authState.user : null;
}

// Is Authenticated Provider
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthAuthenticated;
}

// Is Loading Provider
@riverpod
bool isAuthLoading(IsAuthLoadingRef ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthLoading;
}
