import 'package:equatable/equatable.dart';

class CustomerCategoryEntity extends Equatable {
  final String? categoryId;
  final String? category;
  final String? categoryName;
  final String? categoryImage;
  final String? categoryDescription;

  const CustomerCategoryEntity({
    this.categoryId,
    this.category,
    this.categoryName,
    this.categoryImage,
    this.categoryDescription,
  });

  const CustomerCategoryEntity.empty()
    : categoryId = null,
      category = null,
      categoryName = null,
      categoryImage = null,
      categoryDescription = null;

  @override
  List<Object?> get props => [
    categoryId,
    category,
    categoryName,
    categoryImage,
    categoryDescription,
  ];
}
