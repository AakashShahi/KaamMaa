import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_category/data/model/customer_category_api_model.dart';

part 'get_all_customer_category_dto.g.dart';

@JsonSerializable()
class GetAllCustomerCategoryDto {
  final bool success;
  final int count;
  final List<CustomerCategoryApiModel> data;

  const GetAllCustomerCategoryDto({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllCustomerCategoryDtoToJson(this);

  factory GetAllCustomerCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllCustomerCategoryDtoFromJson(json);
}
