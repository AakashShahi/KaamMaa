import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_reviews/data/model/customer_reviews_api_model.dart';

part 'get_all_reviews_dto.g.dart';

@JsonSerializable()
class GetAllReviewsDto {
  final bool success;
  final List<CustomerReviewsApiModel> data;

  const GetAllReviewsDto({required this.success, required this.data});

  Map<String, dynamic> toJson() => _$GetAllReviewsDtoToJson(this);

  factory GetAllReviewsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllReviewsDtoFromJson(json);
}
