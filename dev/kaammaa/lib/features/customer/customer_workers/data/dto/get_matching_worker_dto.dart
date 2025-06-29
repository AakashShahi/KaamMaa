import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_workers/data/model/customer_worker_api_model.dart';

part 'get_matching_worker_dto.g.dart';

@JsonSerializable()
class GetMatchingWorkerDto {
  final bool success;
  final String? message; // optional if needed
  final int? count;
  final List<CustomerWorkerApiModel> data;

  const GetMatchingWorkerDto({
    required this.success,
    this.count,
    required this.data,
    this.message,
  });

  factory GetMatchingWorkerDto.fromJson(Map<String, dynamic> json) =>
      _$GetMatchingWorkerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetMatchingWorkerDtoToJson(this);
}
