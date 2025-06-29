import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_workers/data/data_source/remote_datasource/customer_worker_remote_datasource.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/repository/customer_worker_repository.dart';

class CustomerWorkerRemoteRepository implements ICustomerWorkerRepository {
  final CustomerWorkerRemoteDatasource _remoteDatasource;
  CustomerWorkerRemoteRepository({
    required CustomerWorkerRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;
  @override
  Future<Either<Failure, List<CustomerWorkerEntity>>> getWorkersWithCategory(
    String? token,
    String category,
  ) async {
    try {
      final matchingWorkers = await _remoteDatasource.getWorkersWithCategory(
        token,
        category,
      );
      return Right(matchingWorkers);
    } catch (e) {
      return Left(
        ApiFailure(
          message: "Failed to fetch matching workers: ${e.toString()}",
        ),
      );
    }
  }
}
