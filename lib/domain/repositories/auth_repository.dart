import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    required UserRole role,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword);
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
  });
  Future<Either<Failure, void>> verifyEmail(String token);
  Future<Either<Failure, void>> resendVerificationEmail();
  Future<Either<Failure, String?>> getAuthToken();
  Future<Either<Failure, void>> refreshToken();
}
