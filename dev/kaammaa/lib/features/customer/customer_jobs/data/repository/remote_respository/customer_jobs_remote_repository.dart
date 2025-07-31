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

  @override
  Future<Either<Failure, void>> cancelJobAssignment(
    String? token,
    String? jobId,
  ) async {
    try {
      await _remoteDatasource.cancelJobAssignment(token, jobId);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to cancel a job: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, List<CustomerJobsEntity>>> getRequestedJobs(
    String? token,
  ) async {
    try {
      final requestedJob = await _remoteDatasource.getRequestedJobs(token);
      return Right(requestedJob);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to fetach requested job: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> acceptRequestedJob(
    String? token,
    String workerId,
    String jobId,
  ) async {
    try {
      await _remoteDatasource.acceptRequestedJob(token, workerId, jobId);
      return Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to accept requested job: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> rejectRequestedJob(
    String? token,
    String jobId,
  ) async {
    try {
      await _remoteDatasource.rejectRequestedJob(token, jobId);
      return Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to reject requested job: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, List<CustomerJobsEntity>>> getInProgressJobs(
    String? token,
  ) async {
    try {
      final inProgressJob = await _remoteDatasource.getInProgressJobs(token);
      return Right(inProgressJob);
    } catch (e) {
      return Left(
        ApiFailure(
          message: "Failed to fetch in progress customer jobs: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CustomerJobsEntity>>> getFailedJobs(
    String? token,
  ) async {
    try {
      final failedJobs = await _remoteDatasource.getFailedJobs(token);
      return Right(failedJobs);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to fetch failed jobs: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteFailedJob(
    String? token,
    String? jobId,
  ) async {
    try {
      await _remoteDatasource.deleteFailedJob(token, jobId);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to delete failed job: ${e.toString()}"),
      );
    }
  }
}
