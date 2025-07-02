import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';

class CustomerJobsEntity extends Equatable {
  final String? jobId;
  final String? postedBy;
  final CustomerWorkerEntity? assignedTo;
  final CustomerCategoryEntity category;
  final String? icon;
  final String description;
  final String location;
  final String date;
  final String time;
  final String? status;
  final bool? deletedByCustomer;
  final bool? deletedByWorker;

  const CustomerJobsEntity({
    this.jobId,
    this.postedBy,
    this.assignedTo,
    required this.category,
    this.icon,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    this.status,
    this.deletedByCustomer,
    this.deletedByWorker,
  });

  @override
  List<Object?> get props => [
    jobId,
    postedBy,
    assignedTo,
    category,
    icon,
    description,
    location,
    date,
    time,
    status,
    deletedByCustomer,
    deletedByWorker,
  ];
}
