import 'package:equatable/equatable.dart';

abstract class SubmitReviewState extends Equatable {
  const SubmitReviewState();

  @override
  List<Object?> get props => [];
}

class SubmitReviewInitial extends SubmitReviewState {}

class SubmitReviewLoading extends SubmitReviewState {}

class SubmitReviewSuccess extends SubmitReviewState {}

class SubmitReviewFailure extends SubmitReviewState {
  final String message;

  const SubmitReviewFailure(this.message);

  @override
  List<Object?> get props => [message];
}
