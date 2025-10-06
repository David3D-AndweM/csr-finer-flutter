import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/milestone.dart';
import '../../../domain/repositories/project_repository.dart';
import '../datasource/project_remote_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Project>>> getProjects({
    String? recipientId,
    ProjectStatus? status,
    ProjectSector? sector,
    int? page,
    int? limit,
  }) async {
    try {
      final projectModels = await remoteDataSource.getAllProjects();
      final projects = projectModels.map((model) => model.toEntity()).toList();
      
      // Apply filters
      var filteredProjects = projects;
      
      if (recipientId != null) {
        filteredProjects = filteredProjects
            .where((project) => project.recipientId == recipientId)
            .toList();
      }
      
      if (status != null) {
        filteredProjects = filteredProjects
            .where((project) => project.status == status)
            .toList();
      }
      
      if (sector != null) {
        filteredProjects = filteredProjects
            .where((project) => project.sector == sector)
            .toList();
      }
      
      // Apply pagination
      if (page != null && limit != null) {
        final startIndex = page * limit;
        final endIndex = (startIndex + limit).clamp(0, filteredProjects.length);
        if (startIndex < filteredProjects.length) {
          filteredProjects = filteredProjects.sublist(startIndex, endIndex);
        } else {
          filteredProjects = [];
        }
      }
      
      return Right(filteredProjects);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch projects: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Project>> getProject(String id) async {
    try {
      final projectModels = await remoteDataSource.getAllProjects();
      final project = projectModels
          .firstWhere((model) => model.id == id)
          .toEntity();
      return Right(project);
    } catch (e) {
      return Left(ServerFailure('Project not found'));
    }
  }

  @override
  Future<Either<Failure, Project>> createProject({
    required String title,
    required String description,
    String? mouId,
    required String recipientId,
    required ProjectSector sector,
    required double estimatedBudget,
    required DateTime startDate,
    required DateTime endDate,
    String? location,
    required int beneficiariesCount,
  }) async {
    // For mock implementation, return a failure as we don't support creation
    return Left(ServerFailure('Create project not implemented in mock data source'));
  }

  @override
  Future<Either<Failure, Project>> updateProject(String id, {
    String? title,
    String? description,
    ProjectSector? sector,
    double? estimatedBudget,
    DateTime? startDate,
    DateTime? endDate,
    ProjectStatus? status,
    int? progressPercentage,
    String? location,
    int? beneficiariesCount,
  }) async {
    // For mock implementation, return a failure as we don't support updates
    return Left(ServerFailure('Update project not implemented in mock data source'));
  }

  @override
  Future<Either<Failure, void>> deleteProject(String id) async {
    // For mock implementation, return a failure as we don't support deletion
    return Left(ServerFailure('Delete project not implemented in mock data source'));
  }

  @override
  Future<Either<Failure, List<Milestone>>> getProjectMilestones(String projectId) async {
    // For mock implementation, return empty list
    return Right([]);
  }

  @override
  Future<Either<Failure, Project>> updateProjectProgress(String id, int progressPercentage) async {
    // For mock implementation, return a failure as we don't support updates
    return Left(ServerFailure('Update project progress not implemented in mock data source'));
  }

  @override
  Future<Either<Failure, Project>> updateProjectExpenditure(String id, double expenditure) async {
    // For mock implementation, return a failure as we don't support updates
    return Left(ServerFailure('Update project expenditure not implemented in mock data source'));
  }

  @override
  Future<Either<Failure, List<Project>>> getProjectsByRecipient(String recipientId) async {
    return getProjects(recipientId: recipientId);
  }

  @override
  Future<Either<Failure, List<Project>>> getProjectsBySector(ProjectSector sector) async {
    return getProjects(sector: sector);
  }

  @override
  Future<Either<Failure, List<Project>>> getOverdueProjects() async {
    try {
      final result = await getProjects();
      return result.fold(
        (failure) => Left(failure),
        (projects) {
          final overdueProjects = projects
              .where((project) => project.isOverdue)
              .toList();
          return Right(overdueProjects);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch overdue projects: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getProjectsNearDeadline(int days) async {
    try {
      final result = await getProjects();
      return result.fold(
        (failure) => Left(failure),
        (projects) {
          final now = DateTime.now();
          final deadline = now.add(Duration(days: days));
          
          final nearDeadlineProjects = projects
              .where((project) => 
                  project.endDate.isAfter(now) && 
                  project.endDate.isBefore(deadline) &&
                  !project.isCompleted)
              .toList();
          return Right(nearDeadlineProjects);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch projects near deadline: ${e.toString()}'));
    }
  }
}