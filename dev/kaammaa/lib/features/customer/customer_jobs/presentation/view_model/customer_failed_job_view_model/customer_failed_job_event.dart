import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CustomerFailedJobsEvent extends Equatable {
  const CustomerFailedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerFailedJobs extends CustomerFailedJobsEvent {}

class DeleteCustomerFailedJob extends CustomerFailedJobsEvent {
  final String jobId;
  final BuildContext context;

  const DeleteCustomerFailedJob({required this.jobId, required this.context});

  @override
  List<Object?> get props => [jobId];
}
