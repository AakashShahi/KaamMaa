import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CustomerRequestedJobsEvent extends Equatable {
  const CustomerRequestedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerRequestedJobs extends CustomerRequestedJobsEvent {}

class AcceptRequestedJobEvent extends CustomerRequestedJobsEvent {
  final String jobId;
  final String workerId;
  final BuildContext context;

  const AcceptRequestedJobEvent({
    required this.jobId,
    required this.workerId,
    required this.context,
  });

  @override
  List<Object?> get props => [jobId, workerId];
}

class RejectRequestedJobEvent extends CustomerRequestedJobsEvent {
  final String jobId;
  final BuildContext context;

  const RejectRequestedJobEvent({required this.jobId, required this.context});

  @override
  List<Object?> get props => [jobId];
}
