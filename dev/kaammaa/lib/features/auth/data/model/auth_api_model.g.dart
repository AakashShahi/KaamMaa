// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      userId: json['_id'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      name: json['name'] as String?,
      profession: json['profession'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      location: json['location'] as String?,
      availability: json['availability'] as bool?,
      certificateUrl: json['certificateUrl'] as String?,
      isVerified: json['isVerified'] as bool?,
      phone: json['phone'] as String,
      profilePic: json['profilePic'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
      'name': instance.name,
      'profession': instance.profession,
      'skills': instance.skills,
      'location': instance.location,
      'availability': instance.availability,
      'certificateUrl': instance.certificateUrl,
      'isVerified': instance.isVerified,
      'phone': instance.phone,
      'profilePic': instance.profilePic,
    };
