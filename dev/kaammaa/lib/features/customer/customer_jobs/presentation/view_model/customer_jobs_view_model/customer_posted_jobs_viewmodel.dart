import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/delete_posted_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_all_public_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_state.dart';

class CustomerPostedJobsViewModel
    extends Bloc<CustomerPostedJobsEvent, CustomerPostedJobsState> {
  final GetAllPublicJobsUsecase _getAllPublicJobsUsecase;
  final DeletePostedJobUsecase _deletePostedJobUsecase;

  CustomerPostedJobsViewModel(
    this._getAllPublicJobsUsecase,
    this._deletePostedJobUsecase,
  ) : super(CustomerPostedJobsInitial()) {
    on<LoadCustomerPostedJobs>((event, emit) async {
      emit(CustomerPostedJobsLoading());

      final result = await _getAllPublicJobsUsecase();
      debugPrint('CustomerPostedJobsViewModel: result: $result');

      result.fold(
        (failure) => emit(CustomerPostedJobsError(failure.message)),
        (jobs) => emit(CustomerPostedJobsLoaded(jobs)),
      );
    });

    on<DeleteCustomerPostedJob>((event, emit) async {
      final jobId = event.jobId;
      final context = event.context;

      final result = await _deletePostedJobUsecase(
        DeletePostedJobParams(jobId: jobId),
      );

      result.fold(
        (failure) {
          AppFlushbar.show(
            context: context,
            message: failure.message,
            backgroundColor: AppColors.error,
            icon: Icon(Icons.delete),
          );
        },
        (_) {
          AppFlushbar.show(
            context: context,
            message: "Post deleted sucessfully",
            backgroundColor: AppColors.success,
            icon: Icon(Icons.done),
          );
          add(LoadCustomerPostedJobs());
        },
      );
    });
  }
}
