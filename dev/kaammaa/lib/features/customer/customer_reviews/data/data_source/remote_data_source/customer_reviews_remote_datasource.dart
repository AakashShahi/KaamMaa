import 'package:dio/dio.dart';
import 'package:kaammaa/app/constant/api/api_endpoints.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/features/customer/customer_reviews/data/data_source/customer_reviews_datasource.dart';
import 'package:kaammaa/features/customer/customer_reviews/data/dto/get_all_reviews_dto.dart';
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

  @override
  Future<List<CustomerReviewsEntity>> getReviews(String? token) async {
    try {
      final response = await _apiService.dio.get(
        "${ApiEndpoints.getReview}/",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        GetAllReviewsDto getAllReviewsDto = GetAllReviewsDto.fromJson(
          response.data,
        );
        return CustomerReviewsApiModel.toEntityList(getAllReviewsDto.data);
      } else {
        throw Exception(
          "Failed to fetch customer reviews: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to get review: ${e.message}");
    } catch (e) {
      throw Exception(
        "An unexpected error occurred while fetching reviews: $e",
      );
    }
  }

  @override
  Future<void> deleteOneReview(String? token, String? reviewId) async {
    try {
      final response = await _apiService.dio.delete(
        "${ApiEndpoints.deleteReview}/$reviewId/",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Future.value();
      } else {
        // Handle unexpected status codes
        throw Exception("Failed to delete reviews: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to delete review: ${e.message}");
    } catch (e) {
      throw Exception(
        "An unexpected error occurred while deleting reviews: $e",
      );
    }
  }

  @override
  Future<void> deleteAllReview(String? token) async {
    try {
      final response = await _apiService.dio.delete(
        "${ApiEndpoints.deleteAllReview}/",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Future.value();
      } else {
        // Handle unexpected status codes
        throw Exception(
          "Failed to delete all reviews: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to delete review: ${e.message}");
    } catch (e) {
      throw Exception(
        "An unexpected error occurred while deleting reviews: $e",
      );
    }
  }
}
