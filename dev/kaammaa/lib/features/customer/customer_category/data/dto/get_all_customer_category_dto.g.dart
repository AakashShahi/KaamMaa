// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_customer_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCustomerCategoryDto _$GetAllCustomerCategoryDtoFromJson(
        Map<String, dynamic> json) =>
    GetAllCustomerCategoryDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              CustomerCategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllCustomerCategoryDtoToJson(
        GetAllCustomerCategoryDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
