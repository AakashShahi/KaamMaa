import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/data_source/remote_data_source.dart/customer_jobs_remote_datasource.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';

class CustomerJobsRemoteRepository implements ICustomerJobsRepository {
  final CustomerJobsRemoteDatasource _remoteDatasource;
  CustomerJobsRemoteRepository({
    required CustomerJobsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<CustomerJobsEntity>>> getPublicJobs(
    String? token,
  ) async {
    try {
      final customerJobs = await _remoteDatasource.getPublicJobs(token);
      return Right(customerJobs);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to fetch customer jobs: ${e.toString()}"),
      );
    }
  }
}
