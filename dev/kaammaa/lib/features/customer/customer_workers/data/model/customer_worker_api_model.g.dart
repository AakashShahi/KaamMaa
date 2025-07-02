// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_worker_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerWorkerApiModel _$CustomerWorkerApiModelFromJson(
        Map<String, dynamic> json) =>
    CustomerWorkerApiModel(
      workerId: json['_id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profilePic: json['profilePic'] as String?,
      location: json['location'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      category: json['profession'] == null
          ? null
          : CustomerCategoryApiModel.fromJson(
              json['profession'] as Map<String, dynamic>),
      name: json['name'] as String?,
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$CustomerWorkerApiModelToJson(
        CustomerWorkerApiModel instance) =>
    <String, dynamic>{
      '_id': instance.workerId,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'profilePic': instance.profilePic,
      'location': instance.location,
      'skills': instance.skills,
      'profession': instance.category,
      'name': instance.name,
      'isVerified': instance.isVerified,
    };
