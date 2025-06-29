// view_model/worker_list_state.dart

import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';

abstract class CustomerWorkerListState extends Equatable {
  const CustomerWorkerListState();

  @override
  List<Object?> get props => [];
}

class CustomerWorkerListInitial extends CustomerWorkerListState {}

class CustomerWorkerListLoading extends CustomerWorkerListState {}

class CustomerWorkerListLoaded extends CustomerWorkerListState {
  final List<CustomerWorkerEntity> workers;

  const CustomerWorkerListLoaded(this.workers);

  @override
  List<Object?> get props => [workers];
}

class CustomerWorkerListError extends CustomerWorkerListState {
  final String message;

  const CustomerWorkerListError(this.message);

  @override
  List<Object?> get props => [message];
}
