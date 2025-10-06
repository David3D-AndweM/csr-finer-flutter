/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'CSR CRM';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Corporate Social Responsibility Management Platform';
  
  // Company Information
  static const String companyName = 'CSR Organization';
  static const String companyEmail = 'info@csrcrm.com';
  static const String supportEmail = 'support@csrcrm.com';
  static const String companyWebsite = 'https://csrcrm.com';
  
  // Database
  static const String databaseName = 'csr_crm.db';
  static const int databaseVersion = 1;
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // Network
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 1000;
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';
  
  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration inputDebounce = Duration(milliseconds: 300);
  
  // Notification
  static const Duration snackBarDuration = Duration(seconds: 4);
  static const Duration toastDuration = Duration(seconds: 3);
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String onboardingKey = 'onboarding_completed';
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String unauthorizedErrorMessage = 'You are not authorized to perform this action.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String logoutSuccessMessage = 'You have been logged out successfully.';
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String passwordChangeSuccessMessage = 'Password changed successfully!';
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableOfflineMode = true;
  
  // Chart Colors
  static const List<String> chartColors = [
    '#2563EB', // Primary Blue
    '#10B981', // Success Green
    '#F59E0B', // Warning Orange
    '#EF4444', // Error Red
    '#06B6D4', // Info Cyan
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#6B7280', // Gray
  ];
  
  // Regular Expressions
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^[\+]?[1-9]?[0-9]{7,15}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';
  
  // Project Defaults
  static const int defaultProjectDuration = 365; // days
  static const double defaultBudgetThreshold = 0.8; // 80%
  static const int defaultMilestoneCount = 5;
  
  // Budget Defaults
  static const double defaultEducationAllocation = 0.3; // 30%
  static const double defaultHealthAllocation = 0.25; // 25%
  static const double defaultInfrastructureAllocation = 0.2; // 20%
  static const double defaultAgricultureAllocation = 0.15; // 15%
  static const double defaultOtherAllocation = 0.1; // 10%
}