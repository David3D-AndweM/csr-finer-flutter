// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get budget => throw _privateConstructorUsedError;
  ProjectStatus get status => throw _privateConstructorUsedError;
  String get sector => throw _privateConstructorUsedError;
  ProjectTimeline get timeline => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get organizationId => throw _privateConstructorUsedError;
  double? get completionPercentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      double budget,
      ProjectStatus status,
      String sector,
      ProjectTimeline timeline,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? imageUrl,
      List<String>? tags,
      String? location,
      String? organizationId,
      double? completionPercentage});

  $ProjectTimelineCopyWith<$Res> get timeline;
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? budget = null,
    Object? status = null,
    Object? sector = null,
    Object? timeline = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? location = freezed,
    Object? organizationId = freezed,
    Object? completionPercentage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
      sector: null == sector
          ? _value.sector
          : sector // ignore: cast_nullable_to_non_nullable
              as String,
      timeline: null == timeline
          ? _value.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as ProjectTimeline,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      completionPercentage: freezed == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProjectTimelineCopyWith<$Res> get timeline {
    return $ProjectTimelineCopyWith<$Res>(_value.timeline, (value) {
      return _then(_value.copyWith(timeline: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
          _$ProjectImpl value, $Res Function(_$ProjectImpl) then) =
      __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      double budget,
      ProjectStatus status,
      String sector,
      ProjectTimeline timeline,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? imageUrl,
      List<String>? tags,
      String? location,
      String? organizationId,
      double? completionPercentage});

  @override
  $ProjectTimelineCopyWith<$Res> get timeline;
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
      _$ProjectImpl _value, $Res Function(_$ProjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? budget = null,
    Object? status = null,
    Object? sector = null,
    Object? timeline = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? location = freezed,
    Object? organizationId = freezed,
    Object? completionPercentage = freezed,
  }) {
    return _then(_$ProjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
      sector: null == sector
          ? _value.sector
          : sector // ignore: cast_nullable_to_non_nullable
              as String,
      timeline: null == timeline
          ? _value.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as ProjectTimeline,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      completionPercentage: freezed == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl implements _Project {
  const _$ProjectImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.budget,
      required this.status,
      required this.sector,
      required this.timeline,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      final List<String>? tags,
      this.location,
      this.organizationId,
      this.completionPercentage})
      : _tags = tags;

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final double budget;
  @override
  final ProjectStatus status;
  @override
  final String sector;
  @override
  final ProjectTimeline timeline;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? imageUrl;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? location;
  @override
  final String? organizationId;
  @override
  final double? completionPercentage;

  @override
  String toString() {
    return 'Project(id: $id, title: $title, description: $description, budget: $budget, status: $status, sector: $sector, timeline: $timeline, createdAt: $createdAt, updatedAt: $updatedAt, imageUrl: $imageUrl, tags: $tags, location: $location, organizationId: $organizationId, completionPercentage: $completionPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sector, sector) || other.sector == sector) &&
            (identical(other.timeline, timeline) ||
                other.timeline == timeline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      budget,
      status,
      sector,
      timeline,
      createdAt,
      updatedAt,
      imageUrl,
      const DeepCollectionEquality().hash(_tags),
      location,
      organizationId,
      completionPercentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(
      this,
    );
  }
}

abstract class _Project implements Project {
  const factory _Project(
      {required final String id,
      required final String title,
      required final String description,
      required final double budget,
      required final ProjectStatus status,
      required final String sector,
      required final ProjectTimeline timeline,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? imageUrl,
      final List<String>? tags,
      final String? location,
      final String? organizationId,
      final double? completionPercentage}) = _$ProjectImpl;

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  double get budget;
  @override
  ProjectStatus get status;
  @override
  String get sector;
  @override
  ProjectTimeline get timeline;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get imageUrl;
  @override
  List<String>? get tags;
  @override
  String? get location;
  @override
  String? get organizationId;
  @override
  double? get completionPercentage;
  @override
  @JsonKey(ignore: true)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectTimeline _$ProjectTimelineFromJson(Map<String, dynamic> json) {
  return _ProjectTimeline.fromJson(json);
}

/// @nodoc
mixin _$ProjectTimeline {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  DateTime? get actualStartDate => throw _privateConstructorUsedError;
  DateTime? get actualEndDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectTimelineCopyWith<ProjectTimeline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectTimelineCopyWith<$Res> {
  factory $ProjectTimelineCopyWith(
          ProjectTimeline value, $Res Function(ProjectTimeline) then) =
      _$ProjectTimelineCopyWithImpl<$Res, ProjectTimeline>;
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      DateTime? actualStartDate,
      DateTime? actualEndDate});
}

/// @nodoc
class _$ProjectTimelineCopyWithImpl<$Res, $Val extends ProjectTimeline>
    implements $ProjectTimelineCopyWith<$Res> {
  _$ProjectTimelineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? actualStartDate = freezed,
    Object? actualEndDate = freezed,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStartDate: freezed == actualStartDate
          ? _value.actualStartDate
          : actualStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndDate: freezed == actualEndDate
          ? _value.actualEndDate
          : actualEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectTimelineImplCopyWith<$Res>
    implements $ProjectTimelineCopyWith<$Res> {
  factory _$$ProjectTimelineImplCopyWith(_$ProjectTimelineImpl value,
          $Res Function(_$ProjectTimelineImpl) then) =
      __$$ProjectTimelineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      DateTime? actualStartDate,
      DateTime? actualEndDate});
}

/// @nodoc
class __$$ProjectTimelineImplCopyWithImpl<$Res>
    extends _$ProjectTimelineCopyWithImpl<$Res, _$ProjectTimelineImpl>
    implements _$$ProjectTimelineImplCopyWith<$Res> {
  __$$ProjectTimelineImplCopyWithImpl(
      _$ProjectTimelineImpl _value, $Res Function(_$ProjectTimelineImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? actualStartDate = freezed,
    Object? actualEndDate = freezed,
  }) {
    return _then(_$ProjectTimelineImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStartDate: freezed == actualStartDate
          ? _value.actualStartDate
          : actualStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndDate: freezed == actualEndDate
          ? _value.actualEndDate
          : actualEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectTimelineImpl implements _ProjectTimeline {
  const _$ProjectTimelineImpl(
      {required this.startDate,
      required this.endDate,
      this.actualStartDate,
      this.actualEndDate});

  factory _$ProjectTimelineImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectTimelineImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final DateTime? actualStartDate;
  @override
  final DateTime? actualEndDate;

  @override
  String toString() {
    return 'ProjectTimeline(startDate: $startDate, endDate: $endDate, actualStartDate: $actualStartDate, actualEndDate: $actualEndDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectTimelineImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.actualStartDate, actualStartDate) ||
                other.actualStartDate == actualStartDate) &&
            (identical(other.actualEndDate, actualEndDate) ||
                other.actualEndDate == actualEndDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, startDate, endDate, actualStartDate, actualEndDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectTimelineImplCopyWith<_$ProjectTimelineImpl> get copyWith =>
      __$$ProjectTimelineImplCopyWithImpl<_$ProjectTimelineImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectTimelineImplToJson(
      this,
    );
  }
}

abstract class _ProjectTimeline implements ProjectTimeline {
  const factory _ProjectTimeline(
      {required final DateTime startDate,
      required final DateTime endDate,
      final DateTime? actualStartDate,
      final DateTime? actualEndDate}) = _$ProjectTimelineImpl;

  factory _ProjectTimeline.fromJson(Map<String, dynamic> json) =
      _$ProjectTimelineImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  DateTime? get actualStartDate;
  @override
  DateTime? get actualEndDate;
  @override
  @JsonKey(ignore: true)
  _$$ProjectTimelineImplCopyWith<_$ProjectTimelineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
