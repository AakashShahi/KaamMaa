import 'package:equatable/equatable.dart';

abstract class CustomerGetReviewsEvent extends Equatable {
  const CustomerGetReviewsEvent();

  @override
  List<Object> get props => [];
}

class GetAllCustomerReviewsEvent extends CustomerGetReviewsEvent {}

class DeleteAllCustomerReviewsEvent extends CustomerGetReviewsEvent {}

class DeleteSingleCustomerReviewEvent extends CustomerGetReviewsEvent {
  final String reviewId;

  const DeleteSingleCustomerReviewEvent(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}
