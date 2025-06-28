import 'package:equatable/equatable.dart';

abstract class CustomerPostedJobsEvent extends Equatable {
  const CustomerPostedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerPostedJobs extends CustomerPostedJobsEvent {}
