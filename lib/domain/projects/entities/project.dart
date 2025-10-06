import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String title,
    required String description,
    required double budget,
    required ProjectStatus status,
    required String sector,
    required ProjectTimeline timeline,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    List<String>? tags,
    String? location,
    String? organizationId,
    double? completionPercentage,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

@freezed
class ProjectTimeline with _$ProjectTimeline {
  const factory ProjectTimeline({
    required DateTime startDate,
    required DateTime endDate,
    DateTime? actualStartDate,
    DateTime? actualEndDate,
  }) = _ProjectTimeline;

  factory ProjectTimeline.fromJson(Map<String, dynamic> json) => _$ProjectTimelineFromJson(json);
}

enum ProjectStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('suspended')
  suspended,
}
