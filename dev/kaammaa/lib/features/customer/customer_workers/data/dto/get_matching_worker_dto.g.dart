// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_matching_worker_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMatchingWorkerDto _$GetMatchingWorkerDtoFromJson(
        Map<String, dynamic> json) =>
    GetMatchingWorkerDto(
      success: json['success'] as bool,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>)
          .map(
              (e) => CustomerWorkerApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$GetMatchingWorkerDtoToJson(
        GetMatchingWorkerDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'count': instance.count,
      'data': instance.data,
    };
