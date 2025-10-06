// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      emailVerified: json['email_verified'] as bool,
      lastLogin: json['last_login'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      organizationId: json['organization_id'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'role': instance.role,
      'status': instance.status,
      'email_verified': instance.emailVerified,
      'last_login': instance.lastLogin,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'organization_id': instance.organizationId,
    };
