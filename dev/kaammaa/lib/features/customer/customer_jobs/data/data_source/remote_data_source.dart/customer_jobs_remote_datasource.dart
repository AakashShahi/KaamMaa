import 'package:dio/dio.dart';
import 'package:kaammaa/app/constant/api/api_endpoints.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/data_source/customer_jobs_datasource.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/dto/get_all_customer_jobs_dto.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/model/customer_jobs_api_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

class CustomerJobsRemoteDatasource implements ICustomerJobsDatasource {
  final ApiService _apiService;
  CustomerJobsRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<CustomerJobsEntity>> getPublicJobs(String? token) async {
    try {
      final response = await _apiService.dio.get(
        "${ApiEndpoints.customerPublicJobs}/",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print("Customer Jobs remote ${response.data}");
      if (response.statusCode == 200) {
        GetAllCustomerJobsDto getAllCustomerJobsDto =
            GetAllCustomerJobsDto.fromJson(response.data);
        print(" Customer Jobs remote ${getAllCustomerJobsDto.data}");
        return CustomerJobsApiModel.toEntityList(getAllCustomerJobsDto.data);
      } else {
        // Handle unexpected status codes
        throw Exception(
          "Failed to fetch customer categories: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch customer categories: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<void> postJob(
    String? token,
    CustomerJobsEntity customerJobsEntity,
  ) async {
    try {
      final customerJobApiModel = CustomerJobsApiModel.fromEntity(
        customerJobsEntity,
      );

      final response = await _apiService.dio.post(
        "${ApiEndpoints.postCustomerJob}/",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: customerJobApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        // Job posted successfully
        return Future.value();
      } else {
        // Handle unexpected status codes
        throw Exception("Failed to post job: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to post job: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred while posting job: $e");
    }
  }

  @override
  Future<void> assignWorkerToJob(
    String? token,
    String jobId,
    String workerId,
  ) async {
    try {
      final response = await _apiService.dio.post(
        "${ApiEndpoints.assignWorkerToJob}/",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {"jobId": jobId, "workerId": workerId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Worker assigned successfully
        return Future.value();
      } else {
        // Handle unexpected status codes
        throw Exception(
          "Failed to assign worker to job: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to assign worker to job: ${e.message}");
    } catch (e) {
      throw Exception(
        "An unexpected error occurred while assigning worker: $e",
      );
    }
  }
}
