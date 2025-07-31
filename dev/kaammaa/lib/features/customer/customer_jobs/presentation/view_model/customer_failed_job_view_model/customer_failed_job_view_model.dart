import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/delete_failed_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_failed_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_failed_job_view_model/customer_failed_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_failed_job_view_model/customer_failed_job_state.dart';

class CustomerFailedJobsViewModel
    extends Bloc<CustomerFailedJobsEvent, CustomerFailedJobsState> {
  final GetFailedJobsUsecase _getFailedJobsUsecase;
  final DeleteFailedJobsUsecase _deleteFailedJobsUsecase;

  CustomerFailedJobsViewModel({
    required GetFailedJobsUsecase getFailedJobsUsecase,
    required DeleteFailedJobsUsecase deleteFailedJobsUsecase,
  }) : _getFailedJobsUsecase = getFailedJobsUsecase,
       _deleteFailedJobsUsecase = deleteFailedJobsUsecase,
       super(CustomerFailedJobsInitial()) {
    on<LoadCustomerFailedJobs>(_onLoadJobs);
    on<DeleteCustomerFailedJob>(_onDeleteJob);
  }

  Future<void> _onLoadJobs(
    LoadCustomerFailedJobs event,
    Emitter<CustomerFailedJobsState> emit,
  ) async {
    emit(CustomerFailedJobsLoading());
    final result = await _getFailedJobsUsecase();

    result.fold(
      (failure) => emit(CustomerFailedJobsError(failure.message)),
      (jobs) => emit(CustomerFailedJobsLoaded(jobs)),
    );
  }

  Future<void> _onDeleteJob(
    DeleteCustomerFailedJob event,
    Emitter<CustomerFailedJobsState> emit,
  ) async {
    final deleteResult = await _deleteFailedJobsUsecase(
      DeleteFailedParams(jobId: event.jobId),
    );

    deleteResult.fold(
      (failure) => AppFlushbar.show(
        context: event.context,
        message: failure.message,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.error, color: Colors.white),
      ),
      (_) {
        AppFlushbar.show(
          context: event.context,
          message: "Job deleted successfully!",
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        add(LoadCustomerFailedJobs());
      },
    );
  }
}
