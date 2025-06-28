// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerCategoryApiModel _$CustomerCategoryApiModelFromJson(
        Map<String, dynamic> json) =>
    CustomerCategoryApiModel(
      categoryId: json['_id'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CustomerCategoryApiModelToJson(
        CustomerCategoryApiModel instance) =>
    <String, dynamic>{
      '_id': instance.categoryId,
      'name': instance.name,
      'icon': instance.icon,
      'category': instance.category,
      'description': instance.description,
    };
