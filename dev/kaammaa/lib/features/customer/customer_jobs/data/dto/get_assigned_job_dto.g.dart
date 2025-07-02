// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_assigned_job_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAssignedJobDto _$GetAssignedJobDtoFromJson(Map<String, dynamic> json) =>
    GetAssignedJobDto(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerJobsApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$GetAssignedJobDtoToJson(GetAssignedJobDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
