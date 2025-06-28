import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';

abstract interface class ICustomerCategoryRepository {
  Future<Either<Failure, List<CustomerCategoryEntity>>> getCustomerCategories(
    String? token,
  );
}
