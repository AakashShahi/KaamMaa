import 'package:dio/dio.dart';
import 'package:kaammaa/app/constant/api/api_endpoints.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/features/customer/customer_category/data/data_source/customer_category_datasource.dart';
import 'package:kaammaa/features/customer/customer_category/data/dto/get_all_customer_category_dto.dart';
import 'package:kaammaa/features/customer/customer_category/data/model/customer_category_api_model.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';

class CustomerCategoryRemoteDatasource implements ICustomerCategoryDataSource {
  final ApiService _apiService;

  CustomerCategoryRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<CustomerCategoryEntity>> getCustomerCategories(
    String? token,
  ) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.customerCategory}/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        GetAllCustomerCategoryDto getAllCustomerCategoryDto =
            GetAllCustomerCategoryDto.fromJson(response.data);

        return CustomerCategoryApiModel.toEntityList(
          getAllCustomerCategoryDto.data,
        );
      } else {
        // Handle unexpected status codes
        throw Exception('Failed to fetch batches: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // Handle DioException
      throw Exception('Failed to fetch batches: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
