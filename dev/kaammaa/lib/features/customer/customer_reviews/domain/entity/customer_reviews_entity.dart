import 'package:equatable/equatable.dart';

class CustomerReviewsEntity extends Equatable {
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

  const CustomerReviewsEntity({
    this.workerId,
    this.reviewId,
    this.jobId,
    this.customerId,
    this.comment,
    required this.rating,
    this.deletedByCustomer,
    this.deletedByWorker,
    this.createdAt,
    this.updatedAt,
  });

  static const empty = CustomerReviewsEntity(rating: 0);

  @override
  List<Object?> get props => [
    reviewId,
    workerId,
    jobId,
    customerId,
    rating,
    comment,
    deletedByCustomer,
    deletedByWorker,
    createdAt,
    updatedAt,
  ];
}
