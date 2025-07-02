import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract class CustomerRequestedJobsState extends Equatable {
  const CustomerRequestedJobsState();

  @override
  List<Object?> get props => [];
}

class CustomerRequestedJobsInitial extends CustomerRequestedJobsState {}

class CustomerRequestedJobsLoading extends CustomerRequestedJobsState {}

class CustomerRequestedJobsLoaded extends CustomerRequestedJobsState {
  final List<CustomerJobsEntity> jobs;

  const CustomerRequestedJobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class CustomerRequestedJobsError extends CustomerRequestedJobsState {
  final String message;

  const CustomerRequestedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}
