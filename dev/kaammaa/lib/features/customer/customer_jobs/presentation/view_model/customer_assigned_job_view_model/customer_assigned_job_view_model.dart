import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/cancel_assigned_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_assigned_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_state.dart';

class CustomerAssignedJobsViewModel
    extends Bloc<CustomerAssignedJobsEvent, CustomerAssignedJobsState> {
  final GetAssignedJobUsecase _getAssignedJobUsecase;
  final CancelAssignedJobUsecase _cancelAssignedJobUsecase;

  CustomerAssignedJobsViewModel({
    required GetAssignedJobUsecase getAssignedJobUsecase,
    required CancelAssignedJobUsecase cancelAssignedJobUsecase,
  }) : _getAssignedJobUsecase = getAssignedJobUsecase,
       _cancelAssignedJobUsecase = cancelAssignedJobUsecase,
       super(CustomerAssignedJobsInitial()) {
    on<LoadCustomerAssignedJobs>(_loadAssignedJobs);
    on<CancelCustomerAssignedJob>(_cancelAssignedJob);
  }

  Future<void> _loadAssignedJobs(
    LoadCustomerAssignedJobs event,
    Emitter<CustomerAssignedJobsState> emit,
  ) async {
    emit(CustomerAssignedJobsLoading());
    final result = await _getAssignedJobUsecase();
    result.fold(
      (failure) => emit(CustomerAssignedJobsError(failure.message)),
      (jobs) => emit(CustomerAssignedJobsLoaded(jobs)),
    );
  }

  Future<void> _cancelAssignedJob(
    CancelCustomerAssignedJob event,
    Emitter<CustomerAssignedJobsState> emit,
  ) async {
    emit(CustomerAssignedJobsCancelling());

    final result = await _cancelAssignedJobUsecase(
      CancelParams(jobId: event.jobId),
    );
    result.fold(
      (failure) {
        AppFlushbar.show(
          context: event.context,
          message: failure.message,
          backgroundColor: AppColors.error,
          icon: const Icon(Icons.error, color: Colors.white),
        );
        add(LoadCustomerAssignedJobs());
      },
      (_) {
        AppFlushbar.show(
          context: event.context,
          message: "Job cancelled successfully",
          backgroundColor: AppColors.success,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        add(LoadCustomerAssignedJobs());
      },
    );
  }
}
