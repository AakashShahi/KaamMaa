import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/model/customer_jobs_api_model.dart';

part 'get_assigned_job_dto.g.dart';

// @JsonSerializable()
// class GetAssignedJobDto {
//   final bool success;
//   final String? message;
//   final List<CustomerAssignedJobApiModel>? data;

//   const GetAssignedJobDto({required this.success, this.data, this.message});

//   Map<String, dynamic> toJson() => _$GetAssignedJobDtoToJson(this);

//   factory GetAssignedJobDto.fromJson(Map<String, dynamic> json) =>
//       _$GetAssignedJobDtoFromJson(json);
// }

@JsonSerializable()
class GetAssignedJobDto {
  final bool success;
  final String? message;
  final List<CustomerJobsApiModel>? data;

  const GetAssignedJobDto({required this.success, this.data, this.message});

  Map<String, dynamic> toJson() => _$GetAssignedJobDtoToJson(this);

  factory GetAssignedJobDto.fromJson(Map<String, dynamic> json) =>
      _$GetAssignedJobDtoFromJson(json);
}
