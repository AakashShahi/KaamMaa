// customer_inprogress_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

@immutable
// 1. Make the base class extend Equatable
abstract class CustomerInProgressJobsState extends Equatable {
  const CustomerInProgressJobsState(); // Add const constructor

  // 2. Add props to the base class
  @override
  List<Object?> get props => [];
}

class CustomerInProgressJobsInitial extends CustomerInProgressJobsState {}

class CustomerInProgressJobsLoading extends CustomerInProgressJobsState {}

class CustomerInProgressJobsLoaded extends CustomerInProgressJobsState {
  final List<CustomerJobsEntity> jobs;
  const CustomerInProgressJobsLoaded({required this.jobs}); // Add const

  // 3. List the properties that define this state's equality
  @override
  List<Object?> get props => [jobs];
}

class CustomerInProgressJobsError extends CustomerInProgressJobsState {
  final String message;
  const CustomerInProgressJobsError({required this.message}); // Add const

  // 4. List the properties that define this state's equality
  @override
  List<Object?> get props => [message];
}
