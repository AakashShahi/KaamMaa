import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/use_case/get_all_review_usecase.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_event.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_state.dart';

class CustomerGetReviewsViewModel
    extends Bloc<CustomerGetReviewsEvent, CustomerGetReviewsState> {
  final GetAllReviewUsecase getAllReviewUsecase;

  CustomerGetReviewsViewModel({required this.getAllReviewUsecase})
    : super(CustomerReviewsInitial()) {
    on<GetAllCustomerReviewsEvent>(_onGetAllReviews);
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
}
