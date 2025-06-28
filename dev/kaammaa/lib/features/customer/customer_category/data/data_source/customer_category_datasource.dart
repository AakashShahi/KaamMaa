import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';

abstract interface class ICustomerCategoryDataSource {
  Future<List<CustomerCategoryEntity>> getCustomerCategories(String? token);
}
