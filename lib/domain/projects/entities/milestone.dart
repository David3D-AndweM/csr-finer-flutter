import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone.freezed.dart';
part 'milestone.g.dart';

@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required String id,
    required String projectId,
    required String title,
    required String description,
    required DateTime dueDate,
    required MilestoneStatus status,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? completionPercentage,
    List<String>? deliverables,
    String? notes,
  }) = _Milestone;

  factory Milestone.fromJson(Map<String, dynamic> json) => _$MilestoneFromJson(json);
}

enum MilestoneStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('overdue')
  overdue,
}
