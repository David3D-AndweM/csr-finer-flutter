/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => 'AppException: $message';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'NetworkException: $message';
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'ServerException: $message';
}

/// Cache related exceptions
class CacheException extends AppException {
  const CacheException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'CacheException: $message';
}

/// Authentication related exceptions
class AuthenticationException extends AppException {
  const AuthenticationException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'AuthenticationException: $message';
}

/// Authorization related exceptions
class AuthorizationException extends AppException {
  const AuthorizationException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'AuthorizationException: $message';
}

/// Validation related exceptions
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;
  
  const ValidationException(String message, this.errors, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'ValidationException: $message';
}

/// HTTP Status Code Exceptions
class BadRequestException extends AppException {
  const BadRequestException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'BadRequestException: $message';
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException extends AppException {
  const ForbiddenException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'ForbiddenException: $message';
}

class NotFoundException extends AppException {
  const NotFoundException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'NotFoundException: $message';
}

class ConflictException extends AppException {
  const ConflictException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'ConflictException: $message';
}

/// Business logic exceptions
class BusinessLogicException extends AppException {
  const BusinessLogicException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'BusinessLogicException: $message';
}

/// Data parsing exceptions
class DataParsingException extends AppException {
  const DataParsingException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'DataParsingException: $message';
}

/// File operation exceptions
class FileOperationException extends AppException {
  const FileOperationException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'FileOperationException: $message';
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'PermissionException: $message';
}

/// Device related exceptions
class DeviceException extends AppException {
  const DeviceException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'DeviceException: $message';
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'TimeoutException: $message';
}

/// Unknown/Unexpected exceptions
class UnexpectedException extends AppException {
  const UnexpectedException(String message, {String? code}) 
      : super(message, code: code);
  
  @override
  String toString() => 'UnexpectedException: $message';
}
