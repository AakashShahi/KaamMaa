import 'package:equatable/equatable.dart';

abstract class CustomerRequestedJobsEvent extends Equatable {
  const CustomerRequestedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerRequestedJobs extends CustomerRequestedJobsEvent {}
