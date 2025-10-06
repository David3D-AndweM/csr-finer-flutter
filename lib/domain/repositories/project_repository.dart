import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/project.dart';
import '../entities/milestone.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<Project>>> getProjects({
    String? recipientId,
    ProjectStatus? status,
    ProjectSector? sector,
    int? page,
    int? limit,
  });
  
  Future<Either<Failure, Project>> getProject(String id);
  
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
  });
  
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
  });
  
  Future<Either<Failure, void>> deleteProject(String id);
  
  Future<Either<Failure, List<Milestone>>> getProjectMilestones(String projectId);
  
  Future<Either<Failure, Project>> updateProjectProgress(String id, int progressPercentage);
  
  Future<Either<Failure, Project>> updateProjectExpenditure(String id, double expenditure);
  
  Future<Either<Failure, List<Project>>> getProjectsByRecipient(String recipientId);
  
  Future<Either<Failure, List<Project>>> getProjectsBySector(ProjectSector sector);
  
  Future<Either<Failure, List<Project>>> getOverdueProjects();
  
  Future<Either<Failure, List<Project>>> getProjectsNearDeadline(int days);
}
