import 'package:flutter/material.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

@immutable
abstract class CustomerInProgressJobsState {}

class CustomerInProgressJobsInitial extends CustomerInProgressJobsState {}

class CustomerInProgressJobsLoading extends CustomerInProgressJobsState {}

class CustomerInProgressJobsLoaded extends CustomerInProgressJobsState {
  final List<CustomerJobsEntity> jobs;
  CustomerInProgressJobsLoaded({required this.jobs});
}

class CustomerInProgressJobsError extends CustomerInProgressJobsState {
  final String message;
  CustomerInProgressJobsError({required this.message});
}
