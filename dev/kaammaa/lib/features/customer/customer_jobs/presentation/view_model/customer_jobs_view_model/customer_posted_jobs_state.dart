import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract class CustomerPostedJobsState extends Equatable {
  const CustomerPostedJobsState();

  @override
  List<Object?> get props => [];
}

class CustomerPostedJobsInitial extends CustomerPostedJobsState {}

class CustomerPostedJobsLoading extends CustomerPostedJobsState {}

class CustomerPostedJobsLoaded extends CustomerPostedJobsState {
  final List<CustomerJobsEntity> jobs;
  const CustomerPostedJobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class CustomerPostedJobsError extends CustomerPostedJobsState {
  final String message;
  const CustomerPostedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}
