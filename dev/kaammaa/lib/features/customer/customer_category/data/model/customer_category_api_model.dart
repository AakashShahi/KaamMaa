import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';

part 'customer_category_api_model.g.dart';

@JsonSerializable()
class CustomerCategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? categoryId;
  final String? name;
  final String? icon;
  final String? category;
  final String? description;

  const CustomerCategoryApiModel({
    this.categoryId,
    this.name,
    this.icon,
    this.category,
    this.description,
  });

  const CustomerCategoryApiModel.empty()
    : categoryId = "",
      name = "",
      icon = "",
      category = "",
      description = "";

  factory CustomerCategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerCategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerCategoryApiModelToJson(this);

  CustomerCategoryEntity toEntity() {
    return CustomerCategoryEntity(
      categoryId: categoryId,
      categoryName: name,
      categoryImage: icon,
      category: category,
      categoryDescription: description,
    );
  }

  static CustomerCategoryApiModel fromEntity(CustomerCategoryEntity entity) {
    return CustomerCategoryApiModel(
      categoryId: entity.categoryId,
      name: entity.categoryName,
      icon: entity.categoryImage,
      category: entity.category,
      description: entity.categoryDescription,
    );
  }

  static List<CustomerCategoryEntity> toEntityList(
    List<CustomerCategoryApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [categoryId, name, icon, category, description];
}
