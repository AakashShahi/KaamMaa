import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/customer/customer_category/domain/use_case/get_all_customer_category_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/post_public_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_state.dart';

class CustomerPostJobsViewModel
    extends Bloc<CustomerPostJobsEvent, CustomerPostJobsState> {
  final PostPublicJobUsecase postPublicJobUsecase;
  final GetAllCustomerCategoryUsecase getCategoriesUsecase;

  CustomerPostJobsViewModel({
    required this.postPublicJobUsecase,
    required this.getCategoriesUsecase,
  }) : super(CustomerPostJobsInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoriesLoading());
      final result = await getCategoriesUsecase.call();

      result.fold(
        (failure) => emit(CategoriesLoadFailure(failure.message)),
        (categories) => emit(CategoriesLoaded(categories)),
      );
    });

    on<PostJobRequested>((event, emit) async {
      emit(CustomerPostJobsLoading());

      final result = await postPublicJobUsecase.call(
        PostJobsWithParams(
          description: event.description,
          location: event.location,
          category: event.category,
          date: event.date,
          time: event.time,
        ),
      );

      result.fold(
        (failure) {
          emit(CustomerPostJobsFailure(failure.message));
          AppFlushbar.show(
            context: event.context,
            message: failure.message,
            backgroundColor: AppColors.error,
            icon: const Icon(Icons.error, color: Colors.white),
          );
        },
        (_) {
          emit(CustomerPostJobsSuccess());
          AppFlushbar.show(
            context: event.context,
            message: "Job posted successfully!",
            backgroundColor: AppColors.success,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
          serviceLocater<CustomerPostedJobsViewModel>().add(
            LoadCustomerPostedJobs(),
          );
          event.onSuccess?.call();
        },
      );
    });
  }
}
