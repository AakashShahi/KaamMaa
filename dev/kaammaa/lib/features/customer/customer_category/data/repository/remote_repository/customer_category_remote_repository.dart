import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/data/data_source/remote_data_source/customer_category_remote_datasource.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_category/domain/repository/customer_category_repository.dart';

class CustomerCategoryRemoteRepository implements ICustomerCategoryRepository {
  final CustomerCategoryRemoteDatasource _customerCategoryRemoteDatasource;

  CustomerCategoryRemoteRepository({
    required CustomerCategoryRemoteDatasource customerCategoryRemoteDatasource,
  }) : _customerCategoryRemoteDatasource = customerCategoryRemoteDatasource;

  @override
  Future<Either<Failure, List<CustomerCategoryEntity>>> getCustomerCategories(
    String? token,
  ) async {
    try {
      final customerCategories = await _customerCategoryRemoteDatasource
          .getCustomerCategories(token);
      return Right(customerCategories);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
