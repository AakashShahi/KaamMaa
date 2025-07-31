import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract interface class ICustomerJobsRepository {
  Future<Either<Failure, List<CustomerJobsEntity>>> getPublicJobs(
    String? token,
  );

  Future<Either<Failure, void>> postJob(
    String? token,
    CustomerJobsEntity customerJobsEntity,
  );

  Future<Either<Failure, void>> assignWorkerToJob(
    String? token,
    String jobId,
    String workerId,
  );

  Future<Either<Failure, void>> deletePostedJob(String? token, String? jobId);

  Future<Either<Failure, List<CustomerJobsEntity>>> getAssignedJob(
    String? token,
  );

  Future<Either<Failure, void>> cancelJobAssignment(
    String? token,
    String? jobId,
  );

  Future<Either<Failure, List<CustomerJobsEntity>>> getRequestedJobs(
    String? token,
  );

  Future<Either<Failure, void>> acceptRequestedJob(
    String? token,
    String workerId,
    String jobId,
  );

  Future<Either<Failure, void>> rejectRequestedJob(String? token, String jobId);

  Future<Either<Failure, List<CustomerJobsEntity>>> getInProgressJobs(
    String? token,
  );

  Future<Either<Failure, List<CustomerJobsEntity>>> getFailedJobs(
    String? token,
  );

  Future<Either<Failure, void>> deleteFailedJob(String? token, String? jobId);
}
