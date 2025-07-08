import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';

part 'customer_reviews_api_model.g.dart';

@JsonSerializable()
class CustomerReviewsApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? reviewId;

  final String? jobId;
  final String? workerId;
  final String? customerId;
  final double rating;
  final String? comment;
  final bool? deletedByWorker;
  final bool? deletedByCustomer;
  final String? createdAt;
  final String? updatedAt;

  const CustomerReviewsApiModel({
    this.reviewId,
    this.jobId,
    this.workerId,
    this.customerId,
    required this.rating,
    this.comment,
    this.deletedByWorker,
    this.deletedByCustomer,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerReviewsApiModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerReviewsApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerReviewsApiModelToJson(this);

  CustomerReviewsEntity toEntity() {
    return CustomerReviewsEntity(
      reviewId: reviewId,
      jobId: jobId,
      workerId: workerId,
      customerId: customerId,
      rating: rating,
      comment: comment,
      deletedByWorker: deletedByWorker ?? false,
      deletedByCustomer: deletedByCustomer ?? false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CustomerReviewsApiModel.fromEntity(CustomerReviewsEntity entity) {
    return CustomerReviewsApiModel(
      reviewId: entity.reviewId,
      jobId: entity.jobId,
      workerId: entity.workerId,
      customerId: entity.customerId,
      rating: entity.rating,
      comment: entity.comment,
      deletedByWorker: entity.deletedByWorker,
      deletedByCustomer: entity.deletedByCustomer,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<CustomerReviewsEntity> toEntityList(
    List<CustomerReviewsApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
    reviewId,
    jobId,
    workerId,
    customerId,
    rating,
    comment,
    deletedByWorker,
    deletedByCustomer,
    createdAt,
    updatedAt,
  ];
}
