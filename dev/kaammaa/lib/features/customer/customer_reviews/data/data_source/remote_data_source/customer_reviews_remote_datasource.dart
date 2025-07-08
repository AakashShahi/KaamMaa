import 'package:dio/dio.dart';
import 'package:kaammaa/app/constant/api/api_endpoints.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/features/customer/customer_reviews/data/data_source/customer_reviews_datasource.dart';
import 'package:kaammaa/features/customer/customer_reviews/data/model/customer_reviews_api_model.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';

class CustomerReviewsRemoteDatasource implements ICustomerReviewsDatasource {
  final ApiService _apiService;

  CustomerReviewsRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> postReviews(
    String? token,
    CustomerReviewsEntity customerReviewsEntity,
  ) async {
    try {
      final customerReviewsApiModel = CustomerReviewsApiModel.fromEntity(
        customerReviewsEntity,
      );

      final response = await _apiService.dio.post(
        "${ApiEndpoints.postReview}/",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: customerReviewsApiModel.toJson(),
      );
      if (response.statusCode == 200) {
        // Job posted successfully
        return Future.value();
      } else {
        // Handle unexpected status codes
        throw Exception("Failed to post review: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to post review: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred while posting reviews: $e");
    }
  }
}
