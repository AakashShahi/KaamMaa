import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_event.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_all_public_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_inprogress_job_usecase.dart';

class CustomerHomeViewModel extends Bloc<CustomerHomeEvent, CustomerHomeState> {
  final GetAllPublicJobsUsecase getAllPublicJobsUsecase;
  final GetInprogressJobUsecase getInprogressJobUsecase;

  CustomerHomeViewModel({
    required this.getAllPublicJobsUsecase,
    required this.getInprogressJobUsecase,
  }) : super(CustomerHomeInitial()) {
    on<LoadCustomerHomeData>(_onLoadCustomerHomeData);
  }

  Future<void> _onLoadCustomerHomeData(
    LoadCustomerHomeData event,
    Emitter<CustomerHomeState> emit,
  ) async {
    emit(CustomerHomeLoading());

    final postedResult = await getAllPublicJobsUsecase();
    final progressResult = await getInprogressJobUsecase();

    postedResult.fold(
      (failure) => emit(CustomerHomeError("Failed to load posted jobs")),
      (postedJobs) {
        progressResult.fold(
          (failure) =>
              emit(CustomerHomeError("Failed to load in-progress jobs")),
          (inProgressJobs) {
            emit(
              CustomerHomeLoaded(
                postedJobsCount: postedJobs.length,
                inProgressJobs: inProgressJobs,
              ),
            );
          },
        );
      },
    );
  }
}
