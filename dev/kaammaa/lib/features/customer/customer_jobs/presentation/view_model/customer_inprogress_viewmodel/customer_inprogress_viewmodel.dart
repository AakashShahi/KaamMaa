import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_inprogress_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_state.dart';

class CustomerInProgressJobsViewModel
    extends Bloc<CustomerInProgressJobsEvent, CustomerInProgressJobsState> {
  final GetInprogressJobUsecase _getInprogressJobUsecase;

  CustomerInProgressJobsViewModel(this._getInprogressJobUsecase)
    : super(CustomerInProgressJobsInitial()) {
    on<LoadCustomerInProgressJobs>((event, emit) async {
      emit(CustomerInProgressJobsLoading());
      final result = await _getInprogressJobUsecase();
      result.fold(
        (Failure failure) =>
            emit(CustomerInProgressJobsError(message: failure.message)),
        (jobs) => emit(CustomerInProgressJobsLoaded(jobs: jobs)),
      );
    });
  }
}
