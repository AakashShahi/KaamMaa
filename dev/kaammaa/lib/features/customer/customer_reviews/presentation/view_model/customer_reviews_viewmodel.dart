import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/use_case/post_review_usecase.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_reviews_event.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_reviews_state.dart';

class SubmitReviewViewModel extends Bloc<SubmitReviewEvent, SubmitReviewState> {
  final PostReviewUsecase postReviewUsecase;

  SubmitReviewViewModel({required this.postReviewUsecase})
    : super(SubmitReviewInitial()) {
    on<SubmitReviewRequested>((event, emit) async {
      emit(SubmitReviewLoading());

      final result = await postReviewUsecase.call(
        PostReviewParams(
          jobId: event.jobId,
          rating: event.rating,
          comment: event.comment,
        ),
      );

      result.fold((failure) => emit(SubmitReviewFailure(failure.message)), (_) {
        emit(SubmitReviewSuccess());

        // Call optional callback
        event.onSuccess?.call();

        // Reload in-progress jobs
        serviceLocater<CustomerInProgressJobsViewModel>().add(
          LoadCustomerInProgressJobs(),
        );

        // Pop view after success
        if (Navigator.canPop(event.context)) {
          Navigator.pop(event.context);
        }
      });
    });
  }
}
