import 'package:equatable/equatable.dart';

abstract class CustomerAssignedJobsEvent extends Equatable {
  const CustomerAssignedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerAssignedJobs extends CustomerAssignedJobsEvent {}
