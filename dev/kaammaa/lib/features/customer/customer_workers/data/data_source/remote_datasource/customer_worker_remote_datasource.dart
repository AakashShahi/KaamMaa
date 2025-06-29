import 'package:dio/dio.dart';
import 'package:kaammaa/app/constant/api/api_endpoints.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/features/customer/customer_workers/data/data_source/customer_worker_datasource.dart';
import 'package:kaammaa/features/customer/customer_workers/data/dto/get_matching_worker_dto.dart';
import 'package:kaammaa/features/customer/customer_workers/data/model/customer_worker_api_model.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';

class CustomerWorkerRemoteDatasource implements ICustomerWorkerDatasource {
  final ApiService _apiService;
  CustomerWorkerRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<CustomerWorkerEntity>> getWorkersWithCategory(
    String? token,
    String category,
  ) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.customerGetWorkers,
        queryParameters: {'category': category},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print("WOrker data ${response.data}");
      if (response.statusCode == 200) {
        GetMatchingWorkerDto getMatchingWorkerDto =
            GetMatchingWorkerDto.fromJson(response.data);
        return CustomerWorkerApiModel.toEntityList(getMatchingWorkerDto.data);
      } else {
        throw Exception("Failed to fetch workers: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch workers: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
