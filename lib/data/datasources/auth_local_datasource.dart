import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthToken(String token);
  Future<void> cacheRefreshToken(String refreshToken);
  Future<void> cacheUser(UserModel user);
  Future<String?> getAuthToken();
  Future<String?> getRefreshToken();
  Future<UserModel?> getCachedUser();
  Future<void> clearAuthData();
  Future<bool> isFirstTime();
  Future<void> setFirstTime(bool isFirstTime);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'cached_user';
  static const String _firstTimeKey = 'is_first_time';

  AuthLocalDataSourceImpl(this._secureStorage, this._sharedPreferences);

  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
    } catch (e) {
      throw CacheException('Failed to cache auth token: $e');
    }
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    } catch (e) {
      throw CacheException('Failed to cache refresh token: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _sharedPreferences.setString(_userKey, userJson);
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: _authTokenKey);
    } catch (e) {
      throw CacheException('Failed to get auth token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _sharedPreferences.getString(_userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _authTokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
        _sharedPreferences.remove(_userKey),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear auth data: $e');
    }
  }

  @override
  Future<bool> isFirstTime() async {
    try {
      return _sharedPreferences.getBool(_firstTimeKey) ?? true;
    } catch (e) {
      throw CacheException('Failed to check first time: $e');
    }
  }

  @override
  Future<void> setFirstTime(bool isFirstTime) async {
    try {
      await _sharedPreferences.setBool(_firstTimeKey, isFirstTime);
    } catch (e) {
      throw CacheException('Failed to set first time: $e');
    }
  }
}
