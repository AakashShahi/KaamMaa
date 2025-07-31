import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract class CustomerFailedJobsState extends Equatable {
  const CustomerFailedJobsState();

  @override
  List<Object?> get props => [];
}

class CustomerFailedJobsInitial extends CustomerFailedJobsState {}

class CustomerFailedJobsLoading extends CustomerFailedJobsState {}

class CustomerFailedJobsLoaded extends CustomerFailedJobsState {
  final List<CustomerJobsEntity> jobs;

  const CustomerFailedJobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class CustomerFailedJobsError extends CustomerFailedJobsState {
  final String message;

  const CustomerFailedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}
