import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_state.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/use_case/get_matching_worker_usecase.dart';

class CustomerWorkerListViewModel
    extends Bloc<CustomerWorkerListEvent, CustomerWorkerListState> {
  final GetMatchingWorkerUsecase getMatchingWorkerUsecase;

  CustomerWorkerListViewModel({required this.getMatchingWorkerUsecase})
    : super(CustomerWorkerListInitial()) {
    on<LoadWorkersByCategory>((event, emit) async {
      emit(CustomerWorkerListLoading());
      final result = await getMatchingWorkerUsecase.call(
        GetWorkerWithParams(category: event.category),
      );

      result.fold(
        (failure) => emit(CustomerWorkerListError(failure.message)),
        (workers) => emit(CustomerWorkerListLoaded(workers)),
      );
    });
  }
}
