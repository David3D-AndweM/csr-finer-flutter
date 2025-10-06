import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final authResponse = await _remoteDataSource.login(email, password);
        
        // Cache tokens and user data
        await _localDataSource.cacheAuthToken(authResponse.accessToken);
        await _localDataSource.cacheRefreshToken(authResponse.refreshToken);
        await _localDataSource.cacheUser(authResponse.user);
        
        return Right(authResponse.user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Login failed: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    required UserRole role,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final authResponse = await _remoteDataSource.register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          role: _mapUserRoleToString(role),
        );
        
        // Cache tokens and user data
        await _localDataSource.cacheAuthToken(authResponse.accessToken);
        await _localDataSource.cacheRefreshToken(authResponse.refreshToken);
        await _localDataSource.cacheUser(authResponse.user);
        
        return Right(authResponse.user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Registration failed: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.logout();
      }
      
      // Always clear local data
      await _localDataSource.clearAuthData();
      
      return const Right(null);
    } on ServerException catch (e) {
      // Still clear local data even if server logout fails
      await _localDataSource.clearAuthData();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await _localDataSource.clearAuthData();
      return Left(UnexpectedFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // First try to get cached user
      final cachedUser = await _localDataSource.getCachedUser();
      
      if (await _networkInfo.isConnected) {
        try {
          // Try to get fresh user data from server
          final remoteUser = await _remoteDataSource.getCurrentUser();
          await _localDataSource.cacheUser(remoteUser);
          return Right(remoteUser.toEntity());
        } on ServerException {
          // If server fails, return cached user if available
          if (cachedUser != null) {
            return Right(cachedUser.toEntity());
          }
          return const Right(null);
        }
      } else {
        // No internet, return cached user
        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        }
        return const Right(null);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.forgotPassword(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Failed to send password reset email: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String token, String newPassword) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.resetPassword(token, newPassword);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Failed to reset password: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.changePassword(oldPassword, newPassword);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Failed to change password: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedUser = await _remoteDataSource.updateProfile(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          avatarUrl: avatarUrl,
        );
        
        // Cache updated user
        await _localDataSource.cacheUser(updatedUser);
        
        return Right(updatedUser.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Failed to update profile: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.verifyEmail(token);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Failed to verify email: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.resendVerificationEmail();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Failed to resend verification email: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthToken() async {
    try {
      final token = await _localDataSource.getAuthToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to get auth token: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    if (await _networkInfo.isConnected) {
      try {
        final refreshToken = await _localDataSource.getRefreshToken();
        if (refreshToken == null) {
          return Left(AuthenticationFailure('No refresh token available'));
        }
        
        final authResponse = await _remoteDataSource.refreshToken(refreshToken);
        
        // Cache new tokens
        await _localDataSource.cacheAuthToken(authResponse.accessToken);
        await _localDataSource.cacheRefreshToken(authResponse.refreshToken);
        
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Failed to refresh token: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  String _mapUserRoleToString(UserRole role) {
    switch (role) {
      case UserRole.csrManager:
        return 'csr_manager';
      case UserRole.recipient:
        return 'recipient';
      case UserRole.financeOfficer:
        return 'finance_officer';
      case UserRole.monitoringEvaluationOfficer:
        return 'monitoring_evaluation_officer';
      case UserRole.editor:
        return 'editor';
    }
  }
}
