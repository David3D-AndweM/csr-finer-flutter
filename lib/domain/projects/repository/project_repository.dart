import 'package:dartz/dartz.dart';
import '../entities/project.dart';
import '../../../core/error/failures.dart';

abstract class ProjectRepository {
  /// Get all projects
  Future<Either<Failure, List<Project>>> getAllProjects();

  /// Get project by ID
  Future<Either<Failure, Project>> getProjectById(String id);

  /// Create a new project
  Future<Either<Failure, void>> createProject(Project project);

  /// Update an existing project
  Future<Either<Failure, void>> updateProject(Project project);

  /// Delete a project
  Future<Either<Failure, void>> deleteProject(String id);

  /// Get projects by status
  Future<Either<Failure, List<Project>>> getProjectsByStatus(ProjectStatus status);

  /// Get projects by organization
  Future<Either<Failure, List<Project>>> getProjectsByOrganization(String organizationId);

  /// Search projects
  Future<Either<Failure, List<Project>>> searchProjects(String query);
}
