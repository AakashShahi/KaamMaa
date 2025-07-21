import 'package:equatable/equatable.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';

abstract class CustomerGetReviewsState extends Equatable {
  const CustomerGetReviewsState();

  @override
  List<Object?> get props => [];
}

class CustomerReviewsInitial extends CustomerGetReviewsState {}

class CustomerReviewsLoading extends CustomerGetReviewsState {}

class CustomerReviewsLoaded extends CustomerGetReviewsState {
  final List<CustomerReviewsEntity> reviews;

  const CustomerReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class CustomerReviewsError extends CustomerGetReviewsState {
  final Failure failure;

  const CustomerReviewsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
