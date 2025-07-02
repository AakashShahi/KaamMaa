import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract class CustomerAssignedJobsState extends Equatable {
  const CustomerAssignedJobsState();

  @override
  List<Object?> get props => [];
}

class CustomerAssignedJobsInitial extends CustomerAssignedJobsState {}

class CustomerAssignedJobsLoading extends CustomerAssignedJobsState {}

class CustomerAssignedJobsLoaded extends CustomerAssignedJobsState {
  final List<CustomerJobsEntity> jobs;

  const CustomerAssignedJobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class CustomerAssignedJobsError extends CustomerAssignedJobsState {
  final String message;

  const CustomerAssignedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CustomerAssignedJobsCancelling extends CustomerAssignedJobsState {}

class CustomerAssignedJobsCancelSuccess extends CustomerAssignedJobsState {}

class CustomerAssignedJobsCancelFailure extends CustomerAssignedJobsState {
  final String message;
  const CustomerAssignedJobsCancelFailure(this.message);

  @override
  List<Object?> get props => [message];
}
