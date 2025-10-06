import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

// Core Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://api.csrcrm.com', // Replace with actual API URL
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
});

final dioClientProvider = Provider<DioClient>((ref) {
  final dio = ref.read(dioProvider);
  return DioClient(dio);
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

// Data Source Providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return AuthRemoteDataSourceImpl(dioClient);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStorage = ref.read(secureStorageProvider);
  final sharedPreferences = ref.read(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(secureStorage, sharedPreferences);
});

// Repository Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  final localDataSource = ref.read(authLocalDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepositoryImpl(
    remoteDataSource,
    localDataSource,
    networkInfo,
  );
});

// Use Case Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});
