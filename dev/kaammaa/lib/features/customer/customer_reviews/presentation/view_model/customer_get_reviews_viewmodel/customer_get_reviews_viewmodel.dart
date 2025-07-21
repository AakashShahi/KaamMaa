import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/use_case/delete_all_review_usecase.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/use_case/delete_review_usecase.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/use_case/get_all_review_usecase.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_event.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_state.dart';

class CustomerGetReviewsViewModel
    extends Bloc<CustomerGetReviewsEvent, CustomerGetReviewsState> {
  final GetAllReviewUsecase getAllReviewUsecase;
  final DeleteAllReviewUsecase deleteAllReviewUsecase;
  final DeleteReviewUsecase deleteReviewUsecase;

  CustomerGetReviewsViewModel({
    required this.getAllReviewUsecase,
    required this.deleteAllReviewUsecase,
    required this.deleteReviewUsecase,
  }) : super(CustomerReviewsInitial()) {
    on<GetAllCustomerReviewsEvent>(_onGetAllReviews);
    on<DeleteAllCustomerReviewsEvent>(_onDeleteAllReviews);
    on<DeleteSingleCustomerReviewEvent>(_onDeleteSingleReview);
  }

  Future<void> _onGetAllReviews(
    GetAllCustomerReviewsEvent event,
    Emitter<CustomerGetReviewsState> emit,
  ) async {
    emit(CustomerReviewsLoading());

    final result = await getAllReviewUsecase();

    result.fold(
      (failure) => emit(CustomerReviewsError(failure)),
      (reviews) => emit(CustomerReviewsLoaded(reviews)),
    );
  }

  Future<void> _onDeleteAllReviews(
    DeleteAllCustomerReviewsEvent event,
    Emitter<CustomerGetReviewsState> emit,
  ) async {
    emit(CustomerReviewsLoading());

    final result = await deleteAllReviewUsecase();
    result.fold(
      (failure) => emit(CustomerReviewsError(failure)),
      (_) => add(GetAllCustomerReviewsEvent()),
    );
  }

  Future<void> _onDeleteSingleReview(
    DeleteSingleCustomerReviewEvent event,
    Emitter<CustomerGetReviewsState> emit,
  ) async {
    emit(CustomerReviewsLoading());

    final result = await deleteReviewUsecase(
      DeleteReviewParams(reviewId: event.reviewId),
    );
    result.fold(
      (failure) => emit(CustomerReviewsError(failure)),
      (_) => add(GetAllCustomerReviewsEvent()),
    );
  }
}
