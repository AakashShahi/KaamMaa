import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_requested_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_state.dart';

class CustomerRequestedJobsViewModel
    extends Bloc<CustomerRequestedJobsEvent, CustomerRequestedJobsState> {
  final GetRequestedJobsUsecase _getRequestedJobsUsecase;

  CustomerRequestedJobsViewModel({
    required GetRequestedJobsUsecase getRequestedJobsUsecase,
  }) : _getRequestedJobsUsecase = getRequestedJobsUsecase,
       super(CustomerRequestedJobsInitial()) {
    on<LoadCustomerRequestedJobs>((event, emit) async {
      emit(CustomerRequestedJobsLoading());
      final result = await _getRequestedJobsUsecase();
      result.fold(
        (failure) => emit(CustomerRequestedJobsError(failure.message)),
        (jobs) => emit(CustomerRequestedJobsLoaded(jobs)),
      );
    });
  }
}
