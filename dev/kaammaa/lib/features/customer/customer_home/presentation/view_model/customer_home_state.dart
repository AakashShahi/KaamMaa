import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract class CustomerHomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CustomerHomeInitial extends CustomerHomeState {}

class CustomerHomeLoading extends CustomerHomeState {}

class CustomerHomeLoaded extends CustomerHomeState {
  final int postedJobsCount;
  final List<CustomerJobsEntity> inProgressJobs;

  CustomerHomeLoaded({
    required this.postedJobsCount,
    required this.inProgressJobs,
  });

  @override
  List<Object?> get props => [postedJobsCount, inProgressJobs];
}

class CustomerHomeError extends CustomerHomeState {
  final String message;

  CustomerHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
