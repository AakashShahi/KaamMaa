import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_assigned_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_state.dart';

class CustomerAssignedJobsViewModel
    extends Bloc<CustomerAssignedJobsEvent, CustomerAssignedJobsState> {
  final GetAssignedJobUsecase _getAssignedJobUsecase;

  CustomerAssignedJobsViewModel(this._getAssignedJobUsecase)
    : super(CustomerAssignedJobsInitial()) {
    on<LoadCustomerAssignedJobs>((event, emit) async {
      emit(CustomerAssignedJobsLoading());
      final result = await _getAssignedJobUsecase();
      result.fold(
        (failure) => emit(CustomerAssignedJobsError(failure.message)),
        (jobs) => emit(CustomerAssignedJobsLoaded(jobs)),
      );
    });
  }
}
