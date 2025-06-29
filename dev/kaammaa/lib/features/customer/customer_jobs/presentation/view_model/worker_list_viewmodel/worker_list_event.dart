import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CustomerWorkerListEvent extends Equatable {
  const CustomerWorkerListEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkersByCategory extends CustomerWorkerListEvent {
  final String category;

  const LoadWorkersByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class AssignWorkerToJob extends CustomerWorkerListEvent {
  final String jobId;
  final String workerId;
  final BuildContext context; // Needed for flushbar

  const AssignWorkerToJob({
    required this.jobId,
    required this.workerId,
    required this.context,
  });

  @override
  List<Object?> get props => [jobId, workerId, context];
}
