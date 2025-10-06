import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validate input
    final validation = _validateInput(params);
    if (validation != null) {
      return Left(ValidationFailure(validation, null));
    }

    return await _repository.login(params.email, params.password);
  }

  String? _validateInput(LoginParams params) {
    if (params.email.isEmpty) {
      return 'Email is required';
    }
    
    if (!_isValidEmail(params.email)) {
      return 'Please enter a valid email address';
    }
    
    if (params.password.isEmpty) {
      return 'Password is required';
    }
    
    if (params.password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}
