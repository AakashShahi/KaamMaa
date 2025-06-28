import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_category/data/model/customer_category_api_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

part 'customer_jobs_api_model.g.dart';

@JsonSerializable()
class CustomerJobsApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? jobId;
  final String? postedBy;
  final String? assignedTo;
  final CustomerCategoryApiModel category;
  final String? icon;
  final String description;
  final String location;
  final String date;
  final String time;
  final String? status;
  final String? review;
  final bool? deletedByCustomer;
  final bool? deletedByWorker;

  const CustomerJobsApiModel({
    this.jobId,
    required this.postedBy,
    this.assignedTo,
    required this.category,
    this.icon,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    this.status,
    this.review,
    this.deletedByCustomer,
    this.deletedByWorker,
  });

  factory CustomerJobsApiModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerJobsApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerJobsApiModelToJson(this);

  CustomerJobsEntity toEntity() {
    return CustomerJobsEntity(
      jobId: jobId,
      postedBy: postedBy,
      assignedTo: assignedTo,
      category: category.toEntity(),
      icon: icon,
      description: description,
      location: location,
      date: date,
      time: time,
      status: status,
      review: review,
      deletedByCustomer: deletedByCustomer ?? false,
      deletedByWorker: deletedByWorker ?? false,
    );
  }

  factory CustomerJobsApiModel.fromEntity(CustomerJobsEntity entity) {
    final customerJob = CustomerJobsApiModel(
      jobId: entity.jobId,
      postedBy: entity.postedBy,
      assignedTo: entity.assignedTo,
      category: CustomerCategoryApiModel.fromEntity(entity.category),
      icon: entity.icon,
      description: entity.description,
      location: entity.location,
      date: entity.date,
      time: entity.time,
      status: entity.status,
      review: entity.review,
      deletedByCustomer: entity.deletedByCustomer,
      deletedByWorker: entity.deletedByWorker,
    );
    return customerJob;
  }

  static List<CustomerJobsEntity> toEntityList(
    List<CustomerJobsApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

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
    review,
    deletedByCustomer,
    deletedByWorker,
  ];
}
