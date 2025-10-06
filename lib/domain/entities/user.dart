import 'package:equatable/equatable.dart';

enum UserRole {
  csrManager,
  recipient,
  financeOfficer,
  monitoringEvaluationOfficer,
  editor,
}

enum UserStatus {
  active,
  inactive,
  suspended,
  pendingVerification,
}

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final UserStatus status;
  final bool emailVerified;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? organizationId;

  const User({
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

  String get fullName => '$firstName $lastName';
  
  String get displayName => fullName.trim().isEmpty ? email : fullName;
  
  bool get isActive => status == UserStatus.active;
  
  bool get canLogin => isActive && emailVerified;
  
  String get roleDisplayName {
    switch (role) {
      case UserRole.csrManager:
        return 'CSR Manager';
      case UserRole.recipient:
        return 'Recipient';
      case UserRole.financeOfficer:
        return 'Finance Officer';
      case UserRole.monitoringEvaluationOfficer:
        return 'M&E Officer';
      case UserRole.editor:
        return 'Editor';
    }
  }
  
  String get statusDisplayName {
    switch (status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.pendingVerification:
        return 'Pending Verification';
    }
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    bool? emailVerified,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? organizationId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      organizationId: organizationId ?? this.organizationId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phone,
        avatarUrl,
        role,
        status,
        emailVerified,
        lastLogin,
        createdAt,
        updatedAt,
        organizationId,
      ];
}
