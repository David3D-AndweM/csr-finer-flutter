// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      budget: (json['budget'] as num).toDouble(),
      status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
      sector: json['sector'] as String,
      timeline:
          ProjectTimeline.fromJson(json['timeline'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      location: json['location'] as String?,
      organizationId: json['organizationId'] as String?,
      completionPercentage: (json['completionPercentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'budget': instance.budget,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'sector': instance.sector,
      'timeline': instance.timeline,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'tags': instance.tags,
      'location': instance.location,
      'organizationId': instance.organizationId,
      'completionPercentage': instance.completionPercentage,
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.active: 'active',
  ProjectStatus.completed: 'completed',
  ProjectStatus.suspended: 'suspended',
};

_$ProjectTimelineImpl _$$ProjectTimelineImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectTimelineImpl(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      actualStartDate: json['actualStartDate'] == null
          ? null
          : DateTime.parse(json['actualStartDate'] as String),
      actualEndDate: json['actualEndDate'] == null
          ? null
          : DateTime.parse(json['actualEndDate'] as String),
    );

Map<String, dynamic> _$$ProjectTimelineImplToJson(
        _$ProjectTimelineImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'actualStartDate': instance.actualStartDate?.toIso8601String(),
      'actualEndDate': instance.actualEndDate?.toIso8601String(),
    };
