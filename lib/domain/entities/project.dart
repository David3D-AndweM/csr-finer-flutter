import 'package:equatable/equatable.dart';

enum ProjectSector {
  education,
  health,
  infrastructure,
  agriculture,
  environment,
  technology,
  communityDevelopment,
  other,
}

enum ProjectStatus {
  planning,
  active,
  onHold,
  completed,
  cancelled,
}

class Project extends Equatable {
  final String id;
  final String projectCode;
  final String title;
  final String description;
  final String? mouId;
  final String recipientId;
  final ProjectSector sector;
  final double estimatedBudget;
  final double actualExpenditure;
  final DateTime startDate;
  final DateTime endDate;
  final ProjectStatus status;
  final int progressPercentage;
  final String? location;
  final int beneficiariesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;

  const Project({
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

  double get remainingBudget => estimatedBudget - actualExpenditure;
  
  bool get isCompleted => status == ProjectStatus.completed;
  
  bool get isActive => status == ProjectStatus.active;
  
  bool get isOverBudget => actualExpenditure > estimatedBudget;
  
  bool get isOverdue => DateTime.now().isAfter(endDate) && !isCompleted;
  
  double get budgetUtilizationPercentage {
    if (estimatedBudget == 0) return 0;
    return (actualExpenditure / estimatedBudget) * 100;
  }
  
  Duration get duration => endDate.difference(startDate);
  
  Duration get remainingDuration {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return Duration.zero;
    return endDate.difference(now);
  }
  
  String get sectorDisplayName {
    switch (sector) {
      case ProjectSector.education:
        return 'Education';
      case ProjectSector.health:
        return 'Health';
      case ProjectSector.infrastructure:
        return 'Infrastructure';
      case ProjectSector.agriculture:
        return 'Agriculture';
      case ProjectSector.environment:
        return 'Environment';
      case ProjectSector.technology:
        return 'Technology';
      case ProjectSector.communityDevelopment:
        return 'Community Development';
      case ProjectSector.other:
        return 'Other';
    }
  }
  
  String get statusDisplayName {
    switch (status) {
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.cancelled:
        return 'Cancelled';
    }
  }

  Project copyWith({
    String? id,
    String? projectCode,
    String? title,
    String? description,
    String? mouId,
    String? recipientId,
    ProjectSector? sector,
    double? estimatedBudget,
    double? actualExpenditure,
    DateTime? startDate,
    DateTime? endDate,
    ProjectStatus? status,
    int? progressPercentage,
    String? location,
    int? beneficiariesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return Project(
      id: id ?? this.id,
      projectCode: projectCode ?? this.projectCode,
      title: title ?? this.title,
      description: description ?? this.description,
      mouId: mouId ?? this.mouId,
      recipientId: recipientId ?? this.recipientId,
      sector: sector ?? this.sector,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      actualExpenditure: actualExpenditure ?? this.actualExpenditure,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      location: location ?? this.location,
      beneficiariesCount: beneficiariesCount ?? this.beneficiariesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectCode,
        title,
        description,
        mouId,
        recipientId,
        sector,
        estimatedBudget,
        actualExpenditure,
        startDate,
        endDate,
        status,
        progressPercentage,
        location,
        beneficiariesCount,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
      ];
}
