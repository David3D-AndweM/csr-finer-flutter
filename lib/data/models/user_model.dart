import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String? phone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String role;
  final String status;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'last_login')
  final String? lastLogin;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'organization_id')
  final String? organizationId;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.status,
    required this.emailVerified,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
    this.organizationId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      avatarUrl: avatarUrl,
      role: _mapStringToUserRole(role),
      status: _mapStringToUserStatus(status),
      emailVerified: emailVerified,
      lastLogin: lastLogin != null ? DateTime.parse(lastLogin!) : null,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      organizationId: organizationId,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      role: _mapUserRoleToString(user.role),
      status: _mapUserStatusToString(user.status),
      emailVerified: user.emailVerified,
      lastLogin: user.lastLogin?.toIso8601String(),
      createdAt: user.createdAt.toIso8601String(),
      updatedAt: user.updatedAt.toIso8601String(),
      organizationId: user.organizationId,
    );
  }

  static UserRole _mapStringToUserRole(String role) {
    switch (role) {
      case 'csr_manager':
        return UserRole.csrManager;
      case 'recipient':
        return UserRole.recipient;
      case 'finance_officer':
        return UserRole.financeOfficer;
      case 'monitoring_evaluation_officer':
        return UserRole.monitoringEvaluationOfficer;
      case 'editor':
        return UserRole.editor;
      default:
        throw ArgumentError('Unknown user role: $role');
    }
  }

  static String _mapUserRoleToString(UserRole role) {
    switch (role) {
      case UserRole.csrManager:
        return 'csr_manager';
      case UserRole.recipient:
        return 'recipient';
      case UserRole.financeOfficer:
        return 'finance_officer';
      case UserRole.monitoringEvaluationOfficer:
        return 'monitoring_evaluation_officer';
      case UserRole.editor:
        return 'editor';
    }
  }

  static UserStatus _mapStringToUserStatus(String status) {
    switch (status) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      case 'suspended':
        return UserStatus.suspended;
      case 'pending_verification':
        return UserStatus.pendingVerification;
      default:
        throw ArgumentError('Unknown user status: $status');
    }
  }

  static String _mapUserStatusToString(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return 'active';
      case UserStatus.inactive:
        return 'inactive';
      case UserStatus.suspended:
        return 'suspended';
      case UserStatus.pendingVerification:
        return 'pending_verification';
    }
  }
}
