import 'package:equatable/equatable.dart';

enum MilestoneStatus {
  pending,
  inProgress,
  completed,
  overdue,
  cancelled,
}

class Milestone extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime? completionDate;
  final int progressPercentage;
  final MilestoneStatus status;
  final String? notes;
  final double budgetAllocated;
  final double budgetSpent;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;

  const Milestone({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completionDate,
    required this.progressPercentage,
    required this.status,
    this.notes,
    required this.budgetAllocated,
    required this.budgetSpent,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
  });

  double get remainingBudget => budgetAllocated - budgetSpent;
  
  bool get isCompleted => status == MilestoneStatus.completed;
  
  bool get isOverdue => DateTime.now().isAfter(dueDate) && !isCompleted;
  
  bool get isOverBudget => budgetSpent > budgetAllocated;
  
  Duration get remainingTime {
    final now = DateTime.now();
    if (now.isAfter(dueDate)) return Duration.zero;
    return dueDate.difference(now);
  }
  
  double get budgetUtilizationPercentage {
    if (budgetAllocated == 0) return 0;
    return (budgetSpent / budgetAllocated) * 100;
  }
  
  String get statusDisplayName {
    switch (status) {
      case MilestoneStatus.pending:
        return 'Pending';
      case MilestoneStatus.inProgress:
        return 'In Progress';
      case MilestoneStatus.completed:
        return 'Completed';
      case MilestoneStatus.overdue:
        return 'Overdue';
      case MilestoneStatus.cancelled:
        return 'Cancelled';
    }
  }

  Milestone copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? completionDate,
    int? progressPercentage,
    MilestoneStatus? status,
    String? notes,
    double? budgetAllocated,
    double? budgetSpent,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return Milestone(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completionDate: completionDate ?? this.completionDate,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      budgetAllocated: budgetAllocated ?? this.budgetAllocated,
      budgetSpent: budgetSpent ?? this.budgetSpent,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        description,
        dueDate,
        completionDate,
        progressPercentage,
        status,
        notes,
        budgetAllocated,
        budgetSpent,
        orderIndex,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
      ];
}
