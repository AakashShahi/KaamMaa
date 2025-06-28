import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_all_public_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_state.dart';

class CustomerPostedJobsViewModel
    extends Bloc<CustomerPostedJobsEvent, CustomerPostedJobsState> {
  final GetAllPublicJobsUsecase _getAllPublicJobsUsecase;

  CustomerPostedJobsViewModel(this._getAllPublicJobsUsecase)
    : super(CustomerPostedJobsInitial()) {
    on<LoadCustomerPostedJobs>((event, emit) async {
      emit(CustomerPostedJobsLoading());

      final result = await _getAllPublicJobsUsecase();
      debugPrint('CustomerPostedJobsViewModel: result: $result');

      result.fold(
        (failure) => emit(CustomerPostedJobsError(failure.message)),
        (jobs) => emit(CustomerPostedJobsLoaded(jobs)),
      );
    });
  }
}
