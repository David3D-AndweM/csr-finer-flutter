import '../../core/network/dio_client.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    required String role,
  });
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
  });
  Future<void> verifyEmail(String token);
  Future<void> resendVerificationEmail();
  Future<AuthResponseModel> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Login failed');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Login failed: $e');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    required String role,
  }) async {
    try {
      final response = await _dioClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'role': role,
        },
      );

      if (response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Registration failed');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post('/auth/logout');
    } catch (e) {
      throw ServerException('Logout failed: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException('Failed to get current user');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get current user: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dioClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      throw ServerException('Failed to send password reset email: $e');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _dioClient.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } catch (e) {
      throw ServerException('Failed to reset password: $e');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _dioClient.post(
        '/auth/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      throw ServerException('Failed to change password: $e');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phone != null) data['phone'] = phone;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      final response = await _dioClient.put('/auth/profile', data: data);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException('Failed to update profile');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update profile: $e');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await _dioClient.post(
        '/auth/verify-email',
        data: {'token': token},
      );
    } catch (e) {
      throw ServerException('Failed to verify email: $e');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      await _dioClient.post('/auth/resend-verification');
    } catch (e) {
      throw ServerException('Failed to resend verification email: $e');
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to refresh token');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to refresh token: $e');
    }
  }
}
