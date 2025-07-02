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

  @override
  Future<Either<Failure, void>> postJob(
    String? token,
    CustomerJobsEntity customerJobsEntity,
  ) async {
    try {
      await _remoteDatasource.postJob(token, customerJobsEntity);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to post job: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> assignWorkerToJob(
    String? token,
    String jobId,
    String workerId,
  ) async {
    try {
      await _remoteDatasource.assignWorkerToJob(token, jobId, workerId);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to assign worker to job: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deletePostedJob(
    String? token,
    String? jobId,
  ) async {
    try {
      await _remoteDatasource.deletePostedJob(token, jobId);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to delete a job: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, List<CustomerJobsEntity>>> getAssignedJob(
    String? token,
  ) async {
    try {
      final assignedJobs = await _remoteDatasource.getAssignedJob(token);
      return Right(assignedJobs);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to fetch customer jobs: ${e.toString()}"),
      );
    }
  }
}
