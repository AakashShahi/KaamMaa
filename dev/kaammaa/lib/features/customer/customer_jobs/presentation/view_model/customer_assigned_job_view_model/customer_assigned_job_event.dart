import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CustomerAssignedJobsEvent extends Equatable {
  const CustomerAssignedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerAssignedJobs extends CustomerAssignedJobsEvent {}

class CancelCustomerAssignedJob extends CustomerAssignedJobsEvent {
  final String jobId;
  final BuildContext context;

  const CancelCustomerAssignedJob(this.jobId, this.context);

  @override
  List<Object?> get props => [jobId, context];
}
