# Development Guidelines and Coding Standards

## Overview

This document outlines the development guidelines, coding standards, and best practices for the CSR CRM Flutter project. Following these standards ensures code consistency, maintainability, and team collaboration efficiency.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Coding Standards](#coding-standards)
3. [Architecture Guidelines](#architecture-guidelines)
4. [State Management](#state-management)
5. [Testing Standards](#testing-standards)
6. [Performance Guidelines](#performance-guidelines)
7. [Security Best Practices](#security-best-practices)
8. [Documentation Standards](#documentation-standards)
9. [Git Workflow](#git-workflow)
10. [Code Review Process](#code-review-process)

## Project Structure

### Clean Architecture Layers

```
lib/
├── core/                     # Core utilities and shared components
│   ├── constants/           # App constants and configuration
│   ├── errors/              # Error handling and exceptions
│   ├── network/             # Network configuration and interceptors
│   ├── theme/               # App theme and styling
│   ├── utils/               # Utility functions and helpers
│   └── widgets/             # Reusable UI components
├── data/                    # Data layer (repositories, data sources)
│   ├── datasources/         # Remote and local data sources
│   ├── models/              # Data models and DTOs
│   └── repositories/        # Repository implementations
├── domain/                  # Business logic layer
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Business use cases
├── presentation/            # UI layer
│   ├── pages/               # Screen/page widgets
│   ├── providers/           # State management providers
│   ├── widgets/             # Page-specific widgets
│   └── routes/              # Navigation and routing
└── main.dart               # App entry point
```

### File Naming Conventions

```dart
// Files: snake_case
user_profile_page.dart
project_repository.dart
auth_service.dart

// Classes: PascalCase
class UserProfilePage extends StatelessWidget {}
class ProjectRepository implements IProjectRepository {}
class AuthService {}

// Variables and functions: camelCase
String userName = 'John Doe';
void fetchUserData() {}

// Constants: SCREAMING_SNAKE_CASE
static const String API_BASE_URL = 'https://api.example.com';
static const int MAX_RETRY_ATTEMPTS = 3;

// Private members: prefix with underscore
String _privateVariable;
void _privateMethod() {}
```

## Coding Standards

### Dart/Flutter Best Practices

#### 1. Code Formatting

```dart
// Use dart format for consistent formatting
// Configure your IDE to format on save

// Good: Proper spacing and indentation
class UserService {
  final ApiClient _apiClient;
  
  UserService(this._apiClient);
  
  Future<User> getUser(String id) async {
    try {
      final response = await _apiClient.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      throw UserNotFoundException('User with id $id not found');
    }
  }
}

// Bad: Inconsistent spacing
class UserService{
final ApiClient _apiClient;
UserService(this._apiClient);
Future<User>getUser(String id)async{
try{
final response=await _apiClient.get('/users/$id');
return User.fromJson(response.data);
}catch(e){
throw UserNotFoundException('User with id $id not found');
}
}
}
```

#### 2. Documentation

```dart
/// Service responsible for managing user authentication and profile data.
/// 
/// This service handles user login, logout, profile updates, and maintains
/// the current user session state.
class UserService {
  /// Authenticates a user with email and password.
  /// 
  /// Returns a [User] object on successful authentication.
  /// Throws [AuthenticationException] if credentials are invalid.
  /// 
  /// Example:
  /// ```dart
  /// final user = await userService.authenticate('user@example.com', 'password');
  /// ```
  Future<User> authenticate(String email, String password) async {
    // Implementation
  }
  
  /// Updates the current user's profile information.
  /// 
  /// [userData] contains the fields to be updated.
  /// Returns `true` if update was successful, `false` otherwise.
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    // Implementation
  }
}
```

#### 3. Error Handling

```dart
// Good: Specific exception types
class UserNotFoundException extends Exception {
  final String message;
  UserNotFoundException(this.message);
  
  @override
  String toString() => 'UserNotFoundException: $message';
}

class NetworkException extends Exception {
  final String message;
  final int? statusCode;
  
  NetworkException(this.message, {this.statusCode});
  
  @override
  String toString() => 'NetworkException: $message (Status: $statusCode)';
}

// Good: Proper error handling in services
class ProjectService {
  Future<List<Project>> getProjects() async {
    try {
      final response = await _apiClient.get('/projects');
      return (response.data as List)
          .map((json) => Project.fromJson(json))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProjectNotFoundException('No projects found');
      }
      throw NetworkException('Failed to fetch projects', 
          statusCode: e.response?.statusCode);
    } catch (e) {
      throw UnexpectedException('Unexpected error occurred: $e');
    }
  }
}
```

#### 4. Null Safety

```dart
// Good: Proper null safety usage
class User {
  final String id;
  final String name;
  final String? email;  // Nullable field
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.name,
    this.email,
    required this.createdAt,
  });
  
  // Safe null checking
  bool get hasEmail => email != null && email!.isNotEmpty;
  
  // Null-aware operators
  String get displayName => name.isEmpty ? (email ?? 'Unknown User') : name;
}

// Good: Safe widget building
class UserProfileWidget extends StatelessWidget {
  final User? user;
  
  const UserProfileWidget({Key? key, this.user}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('No user data available'));
    }
    
    return Column(
      children: [
        Text(user!.name),
        if (user!.hasEmail) Text(user!.email!),
        Text('Member since: ${user!.createdAt.year}'),
      ],
    );
  }
}
```

### Widget Best Practices

#### 1. Widget Composition

```dart
// Good: Small, focused widgets
class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;
  
  const ProjectCard({
    Key? key,
    required this.project,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              _buildDescription(),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            project.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ProjectStatusChip(status: project.status),
      ],
    );
  }
  
  Widget _buildDescription() {
    return Text(
      project.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.grey[600],
      ),
    );
  }
  
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Budget: \$${project.budget.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        ProgressIndicator(progress: project.progress),
      ],
    );
  }
}
```

#### 2. State Management with Riverpod

```dart
// Good: Provider definitions
@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  Future<List<Project>> build() async {
    return await ref.read(projectRepositoryProvider).getProjects();
  }
  
  Future<void> addProject(Project project) async {
    state = const AsyncValue.loading();
    
    try {
      await ref.read(projectRepositoryProvider).createProject(project);
      // Refresh the list
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> updateProject(String id, Project project) async {
    try {
      await ref.read(projectRepositoryProvider).updateProject(id, project);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Good: Consumer usage
class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: projectsAsync.when(
        data: (projects) => _buildProjectsList(projects),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(error),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildProjectsList(List<Project> projects) {
    if (projects.isEmpty) {
      return const EmptyStateWidget(
        title: 'No Projects',
        description: 'Start by creating your first project',
        icon: Icons.folder_open,
      );
    }
    
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(
          project: project,
          onTap: () => _navigateToProjectDetails(context, project),
        );
      },
    );
  }
}
```

## Architecture Guidelines

### Clean Architecture Implementation

#### 1. Domain Layer

```dart
// Entity
class Project {
  final String id;
  final String title;
  final String description;
  final ProjectStatus status;
  final double budget;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.budget,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // Business logic methods
  bool get isCompleted => status == ProjectStatus.completed;
  bool get isOverBudget => progress > 1.0;
  double get remainingBudget => budget * (1.0 - progress);
}

// Repository Interface
abstract class IProjectRepository {
  Future<List<Project>> getProjects();
  Future<Project> getProject(String id);
  Future<Project> createProject(Project project);
  Future<Project> updateProject(String id, Project project);
  Future<void> deleteProject(String id);
}

// Use Case
class GetProjectsUseCase {
  final IProjectRepository _repository;
  
  GetProjectsUseCase(this._repository);
  
  Future<List<Project>> execute() async {
    try {
      final projects = await _repository.getProjects();
      // Apply business rules
      return projects.where((project) => !project.isDeleted).toList();
    } catch (e) {
      throw ProjectFetchException('Failed to fetch projects: $e');
    }
  }
}
```

#### 2. Data Layer

```dart
// Data Model
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final double budget;
  final double progress;
  final String createdAt;
  final String updatedAt;
  
  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.budget,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      budget: (json['budget'] as num).toDouble(),
      progress: (json['progress'] as num).toDouble(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'budget': budget,
      'progress': progress,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  
  // Convert to domain entity
  Project toEntity() {
    return Project(
      id: id,
      title: title,
      description: description,
      status: ProjectStatus.fromString(status),
      budget: budget,
      progress: progress,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

// Repository Implementation
class ProjectRepository implements IProjectRepository {
  final IProjectRemoteDataSource _remoteDataSource;
  final IProjectLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  ProjectRepository(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );
  
  @override
  Future<List<Project>> getProjects() async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteProjects = await _remoteDataSource.getProjects();
        await _localDataSource.cacheProjects(remoteProjects);
        return remoteProjects.map((model) => model.toEntity()).toList();
      } catch (e) {
        // Fallback to cached data
        final cachedProjects = await _localDataSource.getCachedProjects();
        return cachedProjects.map((model) => model.toEntity()).toList();
      }
    } else {
      final cachedProjects = await _localDataSource.getCachedProjects();
      return cachedProjects.map((model) => model.toEntity()).toList();
    }
  }
}
```

## Testing Standards

### Unit Testing

```dart
// test/domain/usecases/get_projects_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([IProjectRepository])
void main() {
  late GetProjectsUseCase useCase;
  late MockIProjectRepository mockRepository;
  
  setUp(() {
    mockRepository = MockIProjectRepository();
    useCase = GetProjectsUseCase(mockRepository);
  });
  
  group('GetProjectsUseCase', () {
    final tProjects = [
      Project(
        id: '1',
        title: 'Test Project',
        description: 'Test Description',
        status: ProjectStatus.active,
        budget: 1000.0,
        progress: 0.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    
    test('should return list of projects when repository call is successful', () async {
      // Arrange
      when(mockRepository.getProjects())
          .thenAnswer((_) async => tProjects);
      
      // Act
      final result = await useCase.execute();
      
      // Assert
      expect(result, equals(tProjects));
      verify(mockRepository.getProjects());
      verifyNoMoreInteractions(mockRepository);
    });
    
    test('should throw ProjectFetchException when repository throws', () async {
      // Arrange
      when(mockRepository.getProjects())
          .thenThrow(Exception('Network error'));
      
      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<ProjectFetchException>()),
      );
    });
  });
}
```

### Widget Testing

```dart
// test/presentation/widgets/project_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectCard', () {
    final testProject = Project(
      id: '1',
      title: 'Test Project',
      description: 'Test Description',
      status: ProjectStatus.active,
      budget: 1000.0,
      progress: 0.5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    testWidgets('should display project information correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectCard(project: testProject),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Test Project'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Budget: \$1000'), findsOneWidget);
    });
    
    testWidgets('should call onTap when card is tapped', (tester) async {
      // Arrange
      bool wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectCard(
              project: testProject,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byType(ProjectCard));
      await tester.pump();
      
      // Assert
      expect(wasTapped, isTrue);
    });
  });
}
```

## Performance Guidelines

### Widget Performance

```dart
// Good: Use const constructors
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Static text'),  // const
        SizedBox(height: 16), // const
      ],
    );
  }
}

// Good: Optimize ListView for large datasets
class ProjectsList extends StatelessWidget {
  final List<Project> projects;
  
  const ProjectsList({Key? key, required this.projects}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemExtent: 120.0, // Fixed height for better performance
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(
          key: ValueKey(project.id), // Stable keys
          project: project,
        );
      },
    );
  }
}

// Good: Use RepaintBoundary for expensive widgets
class ComplexChart extends StatelessWidget {
  final List<DataPoint> data;
  
  const ComplexChart({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ChartPainter(data),
        size: const Size(300, 200),
      ),
    );
  }
}
```

### Memory Management

```dart
// Good: Dispose resources properly
class ProjectDetailsPage extends StatefulWidget {
  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  late StreamSubscription _subscription;
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _subscription = projectStream.listen(_onProjectUpdate);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }
  
  void _onProjectUpdate(Project project) {
    if (mounted) {
      setState(() {
        // Update UI
      });
    }
  }
}
```

## Security Best Practices

### Data Protection

```dart
// Good: Secure storage for sensitive data
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

// Good: Input validation
class ValidationUtils {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      return 'Password must contain uppercase, lowercase, and numbers';
    }
    
    return null;
  }
}
```

## Git Workflow

### Branch Naming Convention

```
feature/user-authentication
feature/project-dashboard
bugfix/login-validation-error
hotfix/critical-security-patch
release/v1.2.0
```

### Commit Message Format

```
type(scope): description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- style: Code style changes
- refactor: Code refactoring
- test: Adding or updating tests
- chore: Maintenance tasks

Examples:
feat(auth): add user login functionality
fix(dashboard): resolve project card loading issue
docs(api): update authentication endpoints
test(user): add unit tests for user service
```

### Pull Request Template

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Code is properly documented
- [ ] No new warnings or errors
- [ ] Tests pass locally
```

## Code Review Process

### Review Checklist

1. **Functionality**
   - Does the code work as intended?
   - Are edge cases handled?
   - Is error handling appropriate?

2. **Code Quality**
   - Is the code readable and maintainable?
   - Are naming conventions followed?
   - Is the code properly structured?

3. **Performance**
   - Are there any performance issues?
   - Is memory usage optimized?
   - Are expensive operations minimized?

4. **Security**
   - Are inputs validated?
   - Is sensitive data protected?
   - Are security best practices followed?

5. **Testing**
   - Are tests comprehensive?
   - Do tests cover edge cases?
   - Are tests maintainable?

### Review Guidelines

- Be constructive and respectful in feedback
- Explain the reasoning behind suggestions
- Approve only when confident in code quality
- Request changes for critical issues
- Use inline comments for specific feedback

## Continuous Integration

### GitHub Actions Workflow

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test --coverage
    - run: flutter build apk --debug
    - run: flutter build web
```

Following these guidelines ensures consistent, maintainable, and high-quality code across the entire CSR CRM project.
