import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/exceptions.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      requestHeader: kDebugMode,
      responseHeader: false,
      error: kDebugMode,
      logPrint: (obj) {
        if (kDebugMode) {
          print(obj);
        }
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        // This will be implemented when auth is set up
        handler.next(options);
      },
      onError: (error, handler) {
        _handleDioError(error);
        handler.next(error);
      },
    ));
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle Dio errors
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode, error.response?.data);
      
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled');
      
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection. Please check your network settings.');
      
      case DioExceptionType.badCertificate:
        return NetworkException('Certificate verification failed');
      
      case DioExceptionType.unknown:
      default:
        return NetworkException('An unexpected error occurred: ${error.message}');
    }
  }

  Exception _handleStatusCode(int? statusCode, dynamic responseData) {
    switch (statusCode) {
      case 400:
        return BadRequestException(
          responseData?['message'] ?? 'Bad request',
        );
      case 401:
        return UnauthorizedException(
          responseData?['message'] ?? 'Unauthorized access',
        );
      case 403:
        return ForbiddenException(
          responseData?['message'] ?? 'Access forbidden',
        );
      case 404:
        return NotFoundException(
          responseData?['message'] ?? 'Resource not found',
        );
      case 409:
        return ConflictException(
          responseData?['message'] ?? 'Conflict occurred',
        );
      case 422:
        return ValidationException(
          responseData?['message'] ?? 'Validation failed',
          responseData?['errors'],
        );
      case 500:
        return ServerException(
          responseData?['message'] ?? 'Internal server error',
        );
      case 502:
        return ServerException('Bad gateway');
      case 503:
        return ServerException('Service unavailable');
      default:
        return NetworkException(
          'HTTP Error $statusCode: ${responseData?['message'] ?? 'Unknown error'}',
        );
    }
  }

  // Add authorization header
  void addAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authorization header
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
