# 🏗️ Architecture Documentation

## Overview

The CSR CRM system follows **Clean Architecture** principles combined with **MVVM (Model-View-ViewModel)** pattern to ensure maintainability, testability, and scalability across all platforms.

## Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)
- **Pages**: Screen-level widgets that represent full application screens
- **Widgets**: Reusable UI components
- **ViewModels**: Business logic controllers using Riverpod StateNotifier
- **State Management**: Riverpod for reactive state management

### 2. Domain Layer (`lib/domain/`)
- **Entities**: Core business objects (User, Project, Budget, etc.)
- **Use Cases**: Business logic operations (CreateProject, UpdateMilestone, etc.)
- **Repositories**: Abstract interfaces for data operations
- **Value Objects**: Immutable objects representing domain concepts

### 3. Data Layer (`lib/data/`)
- **Repositories**: Concrete implementations of domain repositories
- **Data Sources**: Remote (API) and Local (Database) data sources
- **Models**: Data transfer objects with JSON serialization
- **Mappers**: Convert between models and entities

### 4. Core Layer (`lib/core/`)
- **Constants**: Application-wide constants
- **Errors**: Custom exception classes
- **Utils**: Helper functions and utilities
- **Network**: HTTP client configuration
- **Storage**: Local storage abstractions

## Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── storage_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── network_info.dart
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── secure_storage.dart
│   └── utils/
│       ├── date_utils.dart
│       ├── validators.dart
│       └── formatters.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── user_local_datasource.dart
│   │   │   ├── project_local_datasource.dart
│   │   │   └── budget_local_datasource.dart
│   │   └── remote/
│   │       ├── user_remote_datasource.dart
│   │       ├── project_remote_datasource.dart
│   │       └── budget_remote_datasource.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── project_model.dart
│   │   ├── budget_model.dart
│   │   └── milestone_model.dart
│   └── repositories/
│       ├── user_repository_impl.dart
│       ├── project_repository_impl.dart
│       └── budget_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── project.dart
│   │   ├── budget.dart
│   │   ├── milestone.dart
│   │   └── survey.dart
│   ├── repositories/
│   │   ├── user_repository.dart
│   │   ├── project_repository.dart
│   │   └── budget_repository.dart
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   └── logout_usecase.dart
│       ├── projects/
│       │   ├── create_project_usecase.dart
│       │   ├── update_project_usecase.dart
│       │   └── get_projects_usecase.dart
│       └── budgets/
│           ├── create_budget_usecase.dart
│           └── get_budget_usecase.dart
├── presentation/
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   └── register_page.dart
│   │   ├── dashboard/
│   │   │   ├── csr_manager_dashboard.dart
│   │   │   ├── recipient_dashboard.dart
│   │   │   ├── finance_dashboard.dart
│   │   │   ├── me_dashboard.dart
│   │   │   └── editor_dashboard.dart
│   │   ├── projects/
│   │   │   ├── projects_list_page.dart
│   │   │   ├── project_details_page.dart
│   │   │   └── create_project_page.dart
│   │   └── budgets/
│   │       ├── budgets_page.dart
│   │       └── budget_details_page.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── app_bar.dart
│   │   │   ├── loading_widget.dart
│   │   │   └── error_widget.dart
│   │   ├── dashboard/
│   │   │   ├── dashboard_card.dart
│   │   │   └── kpi_widget.dart
│   │   └── forms/
│   │       ├── custom_text_field.dart
│   │       └── custom_dropdown.dart
│   └── viewmodels/
│       ├── auth_viewmodel.dart
│       ├── dashboard_viewmodel.dart
│       ├── projects_viewmodel.dart
│       └── budgets_viewmodel.dart
└── main.dart
```

## State Management with Riverpod

### Providers Structure
```dart
// Data Sources
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>(
  (ref) => UserRemoteDataSourceImpl(ref.read(dioClientProvider)),
);

// Repositories
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(
    remoteDataSource: ref.read(userRemoteDataSourceProvider),
    localDataSource: ref.read(userLocalDataSourceProvider),
  ),
);

// Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(userRepositoryProvider)),
);

// ViewModels
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(ref.read(loginUseCaseProvider)),
);
```

## Navigation Architecture

### Route Structure
```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      routes: [
        GoRoute(
          path: '/projects',
          builder: (context, state) => const ProjectsPage(),
        ),
        GoRoute(
          path: '/budgets',
          builder: (context, state) => const BudgetsPage(),
        ),
      ],
    ),
  ],
);
```

## Error Handling

### Exception Hierarchy
```dart
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}
```

### Failure Handling
```dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
```

## Dependency Injection

### Service Locator Pattern with GetIt
```dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<LocalStorage>(() => LocalStorageImpl());
  
  // Data Sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt(), getIt()),
  );
  
  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt()),
  );
}
```

## Testing Architecture

### Test Structure
```
test/
├── unit/
│   ├── domain/
│   │   └── usecases/
│   ├── data/
│   │   ├── repositories/
│   │   └── datasources/
│   └── presentation/
│       └── viewmodels/
├── widget/
│   ├── pages/
│   └── widgets/
└── integration/
    └── app_test.dart
```

## Platform-Specific Considerations

### Responsive Design
- **Mobile**: Optimized for touch interactions
- **Tablet**: Adaptive layouts with side navigation
- **Desktop**: Full-featured interface with keyboard shortcuts
- **Web**: Progressive web app capabilities

### Platform Channels
```dart
class PlatformService {
  static const platform = MethodChannel('csr_crm/platform');
  
  static Future<String> getPlatformVersion() async {
    return await platform.invokeMethod('getPlatformVersion');
  }
}
```

## Security Architecture

### Authentication Flow
1. User credentials validation
2. JWT token generation/storage
3. Role-based access control
4. Secure token refresh mechanism

### Data Security
- Encrypted local storage for sensitive data
- HTTPS for all network communications
- Input validation and sanitization
- Secure file upload handling

## Performance Optimization

### Strategies
- **Lazy Loading**: Load data on demand
- **Caching**: Local storage for frequently accessed data
- **Pagination**: Efficient data loading for large lists
- **Image Optimization**: Cached network images
- **Code Splitting**: Platform-specific builds

## Monitoring and Analytics

### Implementation
- Crash reporting with Firebase Crashlytics
- Performance monitoring
- User analytics and behavior tracking
- Custom event logging

---

*This architecture ensures scalability, maintainability, and testability across all supported platforms while maintaining clean separation of concerns.*