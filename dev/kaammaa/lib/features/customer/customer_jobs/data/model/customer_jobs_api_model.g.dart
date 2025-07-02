// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_jobs_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerJobsApiModel _$CustomerJobsApiModelFromJson(
        Map<String, dynamic> json) =>
    CustomerJobsApiModel(
      jobId: json['_id'] as String?,
      postedBy: json['postedBy'] as String?,
      assignedTo: json['assignedTo'] == null
          ? null
          : CustomerWorkerApiModel.fromJson(
              json['assignedTo'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : CustomerCategoryApiModel.fromJson(
              json['category'] as Map<String, dynamic>),
      icon: json['icon'] as String?,
      description: json['description'] as String,
      location: json['location'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      status: json['status'] as String?,
      deletedByCustomer: json['deletedByCustomer'] as bool?,
      deletedByWorker: json['deletedByWorker'] as bool?,
    );

Map<String, dynamic> _$CustomerJobsApiModelToJson(
        CustomerJobsApiModel instance) =>
    <String, dynamic>{
      '_id': instance.jobId,
      'postedBy': instance.postedBy,
      'assignedTo': instance.assignedTo,
      'category': instance.category,
      'icon': instance.icon,
      'description': instance.description,
      'location': instance.location,
      'date': instance.date,
      'time': instance.time,
      'status': instance.status,
      'deletedByCustomer': instance.deletedByCustomer,
      'deletedByWorker': instance.deletedByWorker,
    };
