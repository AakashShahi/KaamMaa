// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_reviews_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerReviewsApiModel _$CustomerReviewsApiModelFromJson(
        Map<String, dynamic> json) =>
    CustomerReviewsApiModel(
      reviewId: json['_id'] as String?,
      jobId: json['jobId'] as String?,
      workerId: json['workerId'] == null
          ? null
          : CustomerWorkerApiModel.fromJson(
              json['workerId'] as Map<String, dynamic>),
      customerId: json['customerId'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      deletedByWorker: json['deletedByWorker'] as bool?,
      deletedByCustomer: json['deletedByCustomer'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CustomerReviewsApiModelToJson(
        CustomerReviewsApiModel instance) =>
    <String, dynamic>{
      '_id': instance.reviewId,
      'jobId': instance.jobId,
      'workerId': instance.workerId,
      'customerId': instance.customerId,
      'rating': instance.rating,
      'comment': instance.comment,
      'deletedByWorker': instance.deletedByWorker,
      'deletedByCustomer': instance.deletedByCustomer,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
