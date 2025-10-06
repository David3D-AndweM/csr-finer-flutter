# 🏗️ Clean Architecture + MVVM Design

## Architecture Overview

The CSR CRM Flutter application implements **Clean Architecture** principles combined with **MVVM (Model-View-ViewModel)** pattern to ensure:

- **Separation of Concerns**: Clear boundaries between layers
- **Testability**: Easy unit and integration testing
- **Maintainability**: Modular and scalable codebase
- **Platform Independence**: Business logic independent of UI framework
- **Dependency Inversion**: High-level modules don't depend on low-level modules

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │    Pages    │  │   Widgets   │  │ ViewModels  │             │
│  │             │  │             │  │ (Riverpod)  │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │  Entities   │  │  Use Cases  │  │ Repositories│             │
│  │             │  │             │  │ (Abstract)  │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ Repositories│  │Data Sources │  │   Models    │             │
│  │(Concrete)   │  │(Remote/Local│  │             │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                          CORE LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │  Constants  │  │   Errors    │  │   Utils     │             │
│  │             │  │             │  │             │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

## Detailed Layer Implementation

### 1. Presentation Layer

#### Pages (Views)
```dart
// lib/presentation/pages/dashboard/csr_manager_dashboard.dart
class CSRManagerDashboardPage extends ConsumerWidget {
  const CSRManagerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModelProvider);
    final dashboardViewModel = ref.read(dashboardViewModelProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(title: 'CSR Manager Dashboard'),
      body: dashboardState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidget(error: error),
        data: (dashboardData) => _buildDashboardContent(dashboardData),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildKPICards(data.kpis),
          const SizedBox(height: 16),
          _buildProjectsOverview(data.projects),
          const SizedBox(height: 16),
          _buildBudgetOverview(data.budget),
        ],
      ),
    );
  }
}
```

#### ViewModels (Controllers)
```dart
// lib/presentation/viewmodels/dashboard_viewmodel.dart
@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  FutureOr<DashboardData> build() async {
    return _loadDashboardData();
  }

  Future<DashboardData> _loadDashboardData() async {
    final getDashboardDataUseCase = ref.read(getDashboardDataUseCaseProvider);
    final result = await getDashboardDataUseCase.call(NoParams());
    
    return result.fold(
      (failure) => throw failure,
      (data) => data,
    );
  }

  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadDashboardData());
  }

  Future<void> updateProject(String projectId, ProjectUpdateParams params) async {
    final updateProjectUseCase = ref.read(updateProjectUseCaseProvider);
    final result = await updateProjectUseCase.call(
      UpdateProjectParams(id: projectId, updates: params),
    );
    
    result.fold(
      (failure) => _handleError(failure),
      (_) => refreshDashboard(),
    );
  }

  void _handleError(Failure failure) {
    // Handle error (show snackbar, log, etc.)
    state = AsyncValue.error(failure, StackTrace.current);
  }
}
```

#### State Management with Riverpod
```dart
// lib/presentation/providers/dashboard_providers.dart
@riverpod
Future<List<Project>> userProjects(UserProjectsRef ref) async {
  final getProjectsUseCase = ref.read(getProjectsUseCaseProvider);
  final user = ref.read(currentUserProvider);
  
  final result = await getProjectsUseCase.call(
    GetProjectsParams(userId: user.id),
  );
  
  return result.fold(
    (failure) => throw failure,
    (projects) => projects,
  );
}

@riverpod
Future<BudgetSummary> budgetSummary(BudgetSummaryRef ref) async {
  final getBudgetSummaryUseCase = ref.read(getBudgetSummaryUseCaseProvider);
  final result = await getBudgetSummaryUseCase.call(NoParams());
  
  return result.fold(
    (failure) => throw failure,
    (summary) => summary,
  );
}
```

### 2. Domain Layer

#### Entities
```dart
// lib/domain/entities/project.dart
@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String title,
    required String description,
    required ProjectSector sector,
    required ProjectStatus status,
    required DateTime startDate,
    required DateTime endDate,
    required double estimatedBudget,
    required double actualExpenditure,
    required String organizationId,
    required List<Milestone> milestones,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Project;
}

enum ProjectSector {
  education,
  health,
  infrastructure,
  agriculture,
  other,
}

enum ProjectStatus {
  planning,
  active,
  onHold,
  completed,
  cancelled,
}
```

#### Use Cases
```dart
// lib/domain/usecases/projects/get_projects_usecase.dart
class GetProjectsUseCase implements UseCase<List<Project>, GetProjectsParams> {
  final ProjectRepository repository;

  const GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Project>>> call(GetProjectsParams params) async {
    try {
      final projects = await repository.getProjects(
        userId: params.userId,
        status: params.status,
        sector: params.sector,
        page: params.page,
        limit: params.limit,
      );
      return Right(projects);
    } on ServerException {
      return const Left(ServerFailure('Failed to fetch projects'));
    } on CacheException {
      return const Left(CacheFailure('Failed to load cached projects'));
    }
  }
}

@freezed
class GetProjectsParams with _$GetProjectsParams {
  const factory GetProjectsParams({
    String? userId,
    ProjectStatus? status,
    ProjectSector? sector,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _GetProjectsParams;
}
```

#### Repository Interfaces
```dart
// lib/domain/repositories/project_repository.dart
abstract class ProjectRepository {
  Future<List<Project>> getProjects({
    String? userId,
    ProjectStatus? status,
    ProjectSector? sector,
    int page = 1,
    int limit = 20,
  });

  Future<Project> getProjectById(String id);
  Future<Project> createProject(CreateProjectParams params);
  Future<Project> updateProject(String id, UpdateProjectParams params);
  Future<void> deleteProject(String id);
  
  Future<List<Milestone>> getProjectMilestones(String projectId);
  Future<Milestone> updateMilestone(String projectId, String milestoneId, UpdateMilestoneParams params);
}
```

### 3. Data Layer

#### Repository Implementation
```dart
// lib/data/repositories/project_repository_impl.dart
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final ProjectLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Project>> getProjects({
    String? userId,
    ProjectStatus? status,
    ProjectSector? sector,
    int page = 1,
    int limit = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final projectModels = await remoteDataSource.getProjects(
          userId: userId,
          status: status?.name,
          sector: sector?.name,
          page: page,
          limit: limit,
        );
        
        // Cache the results
        await localDataSource.cacheProjects(projectModels);
        
        return projectModels.map((model) => model.toEntity()).toList();
      } on ServerException {
        // Fallback to cached data
        final cachedModels = await localDataSource.getCachedProjects();
        return cachedModels.map((model) => model.toEntity()).toList();
      }
    } else {
      final cachedModels = await localDataSource.getCachedProjects();
      return cachedModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Project> createProject(CreateProjectParams params) async {
    final projectModel = await remoteDataSource.createProject(
      ProjectModel.fromCreateParams(params),
    );
    return projectModel.toEntity();
  }
}
```

#### Data Sources
```dart
// lib/data/datasources/remote/project_remote_datasource.dart
abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects({
    String? userId,
    String? status,
    String? sector,
    int page = 1,
    int limit = 20,
  });
  
  Future<ProjectModel> getProjectById(String id);
  Future<ProjectModel> createProject(ProjectModel project);
  Future<ProjectModel> updateProject(String id, Map<String, dynamic> updates);
  Future<void> deleteProject(String id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final DioClient dioClient;

  const ProjectRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ProjectModel>> getProjects({
    String? userId,
    String? status,
    String? sector,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (userId != null) 'userId': userId,
      if (status != null) 'status': status,
      if (sector != null) 'sector': sector,
    };

    final response = await dioClient.get(
      '/api/v1/projects',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw ServerException('Failed to fetch projects');
    }
  }
}
```

#### Models
```dart
// lib/data/models/project_model.dart
@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required String id,
    required String title,
    required String description,
    required String sector,
    required String status,
    @JsonKey(name: 'start_date') required String startDate,
    @JsonKey(name: 'end_date') required String endDate,
    @JsonKey(name: 'estimated_budget') required double estimatedBudget,
    @JsonKey(name: 'actual_expenditure') required double actualExpenditure,
    @JsonKey(name: 'organization_id') required String organizationId,
    required List<MilestoneModel> milestones,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}

extension ProjectModelX on ProjectModel {
  Project toEntity() {
    return Project(
      id: id,
      title: title,
      description: description,
      sector: ProjectSector.values.firstWhere(
        (e) => e.name == sector,
        orElse: () => ProjectSector.other,
      ),
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ProjectStatus.planning,
      ),
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      estimatedBudget: estimatedBudget,
      actualExpenditure: actualExpenditure,
      organizationId: organizationId,
      milestones: milestones.map((m) => m.toEntity()).toList(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
```

### 4. Core Layer

#### Base Use Case
```dart
// lib/core/usecases/usecase.dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
```

#### Error Handling
```dart
// lib/core/errors/failures.dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
```

#### Exceptions
```dart
// lib/core/errors/exceptions.dart
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}
```

## Dependency Injection Setup

```dart
// lib/core/di/injection_container.dart
final getIt = GetIt.instance;

Future<void> init() async {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  // Data sources
  getIt.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(),
  );
  
  // Repositories
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => GetProjectsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateProjectUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProjectUseCase(getIt()));
}
```

## Riverpod Providers Setup

```dart
// lib/presentation/providers/providers.dart

// Data Sources
@riverpod
ProjectRemoteDataSource projectRemoteDataSource(ProjectRemoteDataSourceRef ref) {
  return getIt<ProjectRemoteDataSource>();
}

@riverpod
ProjectLocalDataSource projectLocalDataSource(ProjectLocalDataSourceRef ref) {
  return getIt<ProjectLocalDataSource>();
}

// Repositories
@riverpod
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  return getIt<ProjectRepository>();
}

// Use Cases
@riverpod
GetProjectsUseCase getProjectsUseCase(GetProjectsUseCaseRef ref) {
  return getIt<GetProjectsUseCase>();
}

@riverpod
CreateProjectUseCase createProjectUseCase(CreateProjectUseCaseRef ref) {
  return getIt<CreateProjectUseCase>();
}
```

## Testing Strategy

### Unit Tests
```dart
// test/domain/usecases/get_projects_usecase_test.dart
void main() {
  late GetProjectsUseCase useCase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    useCase = GetProjectsUseCase(mockRepository);
  });

  group('GetProjectsUseCase', () {
    test('should return list of projects when repository call is successful', () async {
      // Arrange
      final tProjects = [tProject1, tProject2];
      when(mockRepository.getProjects()).thenAnswer((_) async => tProjects);

      // Act
      final result = await useCase(const GetProjectsParams());

      // Assert
      expect(result, Right(tProjects));
      verify(mockRepository.getProjects());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

### Widget Tests
```dart
// test/presentation/pages/dashboard_page_test.dart
void main() {
  testWidgets('should display loading indicator when state is loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardViewModelProvider.overrideWith(
            () => MockDashboardViewModel(),
          ),
        ],
        child: const MaterialApp(
          home: CSRManagerDashboardPage(),
        ),
      ),
    );

    expect(find.byType(LoadingWidget), findsOneWidget);
  });
}
```

## Benefits of This Architecture

### 1. **Testability**
- Each layer can be tested independently
- Easy mocking of dependencies
- Clear separation of business logic from UI

### 2. **Maintainability**
- Changes in one layer don't affect others
- Easy to add new features
- Clear code organization

### 3. **Scalability**
- Easy to add new data sources
- Simple to extend functionality
- Modular architecture supports team development

### 4. **Platform Independence**
- Business logic is framework-agnostic
- Easy to port to different platforms
- Consistent behavior across platforms

### 5. **Error Handling**
- Centralized error handling
- Consistent error propagation
- Easy to add logging and monitoring

---

*This Clean Architecture + MVVM design ensures the CSR CRM application is robust, maintainable, and scalable across all supported platforms.*