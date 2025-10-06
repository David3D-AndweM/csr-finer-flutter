import '../../domain/entities/project.dart';

class ProjectModel {
  final String id;
  final String projectCode;
  final String title;
  final String description;
  final String? mouId;
  final String recipientId;
  final String sector;
  final double estimatedBudget;
  final double actualExpenditure;
  final String startDate;
  final String endDate;
  final String status;
  final int progressPercentage;
  final String? location;
  final int beneficiariesCount;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String? updatedBy;

  const ProjectModel({
    required this.id,
    required this.projectCode,
    required this.title,
    required this.description,
    this.mouId,
    required this.recipientId,
    required this.sector,
    required this.estimatedBudget,
    required this.actualExpenditure,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.progressPercentage,
    this.location,
    required this.beneficiariesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      projectCode: json['project_code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      mouId: json['mou_id'] as String?,
      recipientId: json['recipient_id'] as String,
      sector: json['sector'] as String,
      estimatedBudget: (json['estimated_budget'] as num).toDouble(),
      actualExpenditure: (json['actual_expenditure'] as num).toDouble(),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      status: json['status'] as String,
      progressPercentage: json['progress_percentage'] as int,
      location: json['location'] as String?,
      beneficiariesCount: json['beneficiaries_count'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      createdBy: json['created_by'] as String,
      updatedBy: json['updated_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_code': projectCode,
      'title': title,
      'description': description,
      'mou_id': mouId,
      'recipient_id': recipientId,
      'sector': sector,
      'estimated_budget': estimatedBudget,
      'actual_expenditure': actualExpenditure,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'progress_percentage': progressPercentage,
      'location': location,
      'beneficiaries_count': beneficiariesCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }

  Project toEntity() {
    return Project(
      id: id,
      projectCode: projectCode,
      title: title,
      description: description,
      mouId: mouId,
      recipientId: recipientId,
      sector: _parseSector(sector),
      estimatedBudget: estimatedBudget,
      actualExpenditure: actualExpenditure,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      status: _parseStatus(status),
      progressPercentage: progressPercentage,
      location: location,
      beneficiariesCount: beneficiariesCount,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      projectCode: project.projectCode,
      title: project.title,
      description: project.description,
      mouId: project.mouId,
      recipientId: project.recipientId,
      sector: project.sector.name,
      estimatedBudget: project.estimatedBudget,
      actualExpenditure: project.actualExpenditure,
      startDate: project.startDate.toIso8601String(),
      endDate: project.endDate.toIso8601String(),
      status: project.status.name,
      progressPercentage: project.progressPercentage,
      location: project.location,
      beneficiariesCount: project.beneficiariesCount,
      createdAt: project.createdAt.toIso8601String(),
      updatedAt: project.updatedAt.toIso8601String(),
      createdBy: project.createdBy,
      updatedBy: project.updatedBy,
    );
  }

  ProjectSector _parseSector(String sector) {
    switch (sector.toLowerCase()) {
      case 'education':
        return ProjectSector.education;
      case 'health':
        return ProjectSector.health;
      case 'infrastructure':
        return ProjectSector.infrastructure;
      case 'agriculture':
        return ProjectSector.agriculture;
      case 'environment':
        return ProjectSector.environment;
      case 'technology':
        return ProjectSector.technology;
      case 'communitydevelopment':
      case 'community_development':
        return ProjectSector.communityDevelopment;
      default:
        return ProjectSector.other;
    }
  }

  ProjectStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'planning':
        return ProjectStatus.planning;
      case 'active':
        return ProjectStatus.active;
      case 'onhold':
      case 'on_hold':
        return ProjectStatus.onHold;
      case 'completed':
        return ProjectStatus.completed;
      case 'cancelled':
        return ProjectStatus.cancelled;
      default:
        return ProjectStatus.planning;
    }
  }
}