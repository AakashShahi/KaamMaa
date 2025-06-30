import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CustomerPostedJobsEvent extends Equatable {
  const CustomerPostedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerPostedJobs extends CustomerPostedJobsEvent {}

class DeleteCustomerPostedJob extends CustomerPostedJobsEvent {
  final String jobId;
  final BuildContext context;

  const DeleteCustomerPostedJob({required this.jobId, required this.context});

  @override
  List<Object?> get props => [jobId];
}
