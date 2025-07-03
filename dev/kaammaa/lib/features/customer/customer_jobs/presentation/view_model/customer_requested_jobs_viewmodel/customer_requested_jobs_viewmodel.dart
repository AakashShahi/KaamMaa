import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/accept_requested_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_requested_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/reject_requested_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_state.dart';

class CustomerRequestedJobsViewModel
    extends Bloc<CustomerRequestedJobsEvent, CustomerRequestedJobsState> {
  final GetRequestedJobsUsecase _getRequestedJobsUsecase;
  final AcceptRequestedJobUsecase _acceptRequestedJobUsecase;
  final RejectRequestedJobUsecase _rejectRequestedJobUsecase;

  CustomerRequestedJobsViewModel({
    required GetRequestedJobsUsecase getRequestedJobsUsecase,
    required AcceptRequestedJobUsecase acceptRequestedJobUsecase,
    required RejectRequestedJobUsecase rejectRequestedJobUsecase,
  }) : _getRequestedJobsUsecase = getRequestedJobsUsecase,
       _acceptRequestedJobUsecase = acceptRequestedJobUsecase,
       _rejectRequestedJobUsecase = rejectRequestedJobUsecase,
       super(CustomerRequestedJobsInitial()) {
    on<LoadCustomerRequestedJobs>((event, emit) async {
      emit(CustomerRequestedJobsLoading());
      final result = await _getRequestedJobsUsecase();
      result.fold(
        (failure) => emit(CustomerRequestedJobsError(failure.message)),
        (jobs) => emit(CustomerRequestedJobsLoaded(jobs)),
      );
    });

    on<AcceptRequestedJobEvent>((event, emit) async {
      final result = await _acceptRequestedJobUsecase(
        AcceptRequestParams(jobId: event.jobId, workerId: event.workerId),
      );

      result.fold(
        (failure) => AppFlushbar.show(
          context: event.context,
          message: failure.message,
          backgroundColor: AppColors.error,
          icon: Icon(Icons.sms_failed),
        ),
        (_) {
          AppFlushbar.show(
            context: event.context,
            message: 'Accepted request of worker',
            backgroundColor: AppColors.success,
            icon: Icon(Icons.done),
          );
          add(LoadCustomerRequestedJobs());
        },
      );
    });

    on<RejectRequestedJobEvent>((event, emit) async {
      final result = await _rejectRequestedJobUsecase(
        RejectJobParams(jobId: event.jobId),
      );

      result.fold(
        (failure) => AppFlushbar.show(
          context: event.context,
          message: failure.message,
          backgroundColor: AppColors.error,
          icon: Icon(Icons.sms_failed),
        ),
        (_) {
          AppFlushbar.show(
            context: event.context,
            message: 'Rejected request of worker',
            backgroundColor: AppColors.success,
            icon: Icon(Icons.done),
          );
          add(LoadCustomerRequestedJobs());
        },
      );
    });
  }
}
