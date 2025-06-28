// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_customer_jobs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCustomerJobsDto _$GetAllCustomerJobsDtoFromJson(
        Map<String, dynamic> json) =>
    GetAllCustomerJobsDto(
      success: json['success'] as bool,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => CustomerJobsApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllCustomerJobsDtoToJson(
        GetAllCustomerJobsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
