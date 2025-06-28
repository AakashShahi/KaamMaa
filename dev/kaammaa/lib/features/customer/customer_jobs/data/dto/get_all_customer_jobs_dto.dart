import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/model/customer_jobs_api_model.dart';

part 'get_all_customer_jobs_dto.g.dart';

@JsonSerializable()
class GetAllCustomerJobsDto {
  final bool success;
  final int? count; // ✅ Now nullable
  final List<CustomerJobsApiModel> data;

  const GetAllCustomerJobsDto({
    required this.success,
    this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllCustomerJobsDtoToJson(this);

  factory GetAllCustomerJobsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllCustomerJobsDtoFromJson(json);
}
