import 'package:equatable/equatable.dart';

abstract class CustomerGetReviewsEvent extends Equatable {
  const CustomerGetReviewsEvent();

  @override
  List<Object> get props => [];
}

class GetAllCustomerReviewsEvent extends CustomerGetReviewsEvent {}
