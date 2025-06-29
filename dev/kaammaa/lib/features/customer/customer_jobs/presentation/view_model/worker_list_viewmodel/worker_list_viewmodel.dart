import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/assign_worker_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_state.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/use_case/get_matching_worker_usecase.dart';

class CustomerWorkerListViewModel
    extends Bloc<CustomerWorkerListEvent, CustomerWorkerListState> {
  final GetMatchingWorkerUsecase getMatchingWorkerUsecase;
  final AssignWorkerUsecase assignWorkerUsecase;

  CustomerWorkerListViewModel({
    required this.getMatchingWorkerUsecase,
    required this.assignWorkerUsecase,
  }) : super(CustomerWorkerListInitial()) {
    on<LoadWorkersByCategory>(_onLoadWorkers);
    on<AssignWorkerToJob>(_onAssignWorker);
  }

  Future<void> _onLoadWorkers(
    LoadWorkersByCategory event,
    Emitter<CustomerWorkerListState> emit,
  ) async {
    emit(CustomerWorkerListLoading());
    final result = await getMatchingWorkerUsecase.call(
      GetWorkerWithParams(category: event.category),
    );

    result.fold(
      (failure) => emit(CustomerWorkerListError(failure.message)),
      (workers) => emit(CustomerWorkerListLoaded(workers)),
    );
  }

  Future<void> _onAssignWorker(
    AssignWorkerToJob event,
    Emitter<CustomerWorkerListState> emit,
  ) async {
    final jobId = event.jobId;
    final workerId = event.workerId;

    if (jobId.isEmpty || workerId.isEmpty) {
      await AppFlushbar.show(
        context: event.context,
        message: "Invalid job or worker ID.",
        backgroundColor: AppColors.error,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }

    final result = await assignWorkerUsecase.call(
      AssignWorkerParams(jobId: jobId, workerId: workerId),
    );

    await result.fold(
      (failure) async {
        await AppFlushbar.show(
          context: event.context,
          message: "Failed to assign worker: ${failure.message}",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      },
      (_) async {
        await AppFlushbar.show(
          context: event.context,
          message: "Worker assigned successfully!",
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      },
    );

    serviceLocater<CustomerPostedJobsViewModel>().add(LoadCustomerPostedJobs());
    Navigator.of(event.context).pop(true);
  }
}
