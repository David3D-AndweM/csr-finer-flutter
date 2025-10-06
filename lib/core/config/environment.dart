import 'package:flutter/foundation.dart';

enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment _environment = Environment.development;
  
  static Environment get environment => _environment;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;
  
  static bool get isDebugMode => kDebugMode;
  static bool get isReleaseMode => kReleaseMode;
  static bool get isProfileMode => kProfileMode;
  
  // API Configuration
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'https://dev-api.csrcrm.com/api/v1';
      case Environment.staging:
        return 'https://staging-api.csrcrm.com/api/v1';
      case Environment.production:
        return 'https://api.csrcrm.com/api/v1';
    }
  }
  
  static String get websocketUrl {
    switch (_environment) {
      case Environment.development:
        return 'wss://dev-ws.csrcrm.com';
      case Environment.staging:
        return 'wss://staging-ws.csrcrm.com';
      case Environment.production:
        return 'wss://ws.csrcrm.com';
    }
  }
  
  // Database Configuration
  static String get databaseName {
    switch (_environment) {
      case Environment.development:
        return 'csr_crm_dev.db';
      case Environment.staging:
        return 'csr_crm_staging.db';
      case Environment.production:
        return 'csr_crm.db';
    }
  }
  
  // Logging Configuration
  static bool get enableLogging {
    switch (_environment) {
      case Environment.development:
        return true;
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }
  
  // Analytics Configuration
  static bool get enableAnalytics {
    switch (_environment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  static bool get enableCrashReporting {
    switch (_environment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  // Cache Configuration
  static Duration get cacheExpiration {
    switch (_environment) {
      case Environment.development:
        return const Duration(minutes: 5);
      case Environment.staging:
        return const Duration(hours: 1);
      case Environment.production:
        return const Duration(hours: 24);
    }
  }
  
  // Network Configuration
  static Duration get connectionTimeout {
    switch (_environment) {
      case Environment.development:
        return const Duration(seconds: 60);
      case Environment.staging:
        return const Duration(seconds: 30);
      case Environment.production:
        return const Duration(seconds: 30);
    }
  }
  
  static int get maxRetryAttempts {
    switch (_environment) {
      case Environment.development:
        return 1;
      case Environment.staging:
        return 2;
      case Environment.production:
        return 3;
    }
  }
  
  // File Upload Configuration
  static int get maxFileSize {
    switch (_environment) {
      case Environment.development:
        return 50 * 1024 * 1024; // 50MB
      case Environment.staging:
        return 20 * 1024 * 1024; // 20MB
      case Environment.production:
        return 10 * 1024 * 1024; // 10MB
    }
  }
  
  // Pagination Configuration
  static int get defaultPageSize {
    switch (_environment) {
      case Environment.development:
        return 10;
      case Environment.staging:
        return 15;
      case Environment.production:
        return 20;
    }
  }
  
  // Environment Display Name
  static String get environmentName {
    switch (_environment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
  
  // Print environment info
  static void printEnvironmentInfo() {
    if (enableLogging) {
      print('=== CSR CRM Environment Info ===');
      print('Environment: $environmentName');
      print('API Base URL: $apiBaseUrl');
      print('WebSocket URL: $websocketUrl');
      print('Database Name: $databaseName');
      print('Debug Mode: $isDebugMode');
      print('Logging Enabled: $enableLogging');
      print('Analytics Enabled: $enableAnalytics');
      print('================================');
    }
  }
}
