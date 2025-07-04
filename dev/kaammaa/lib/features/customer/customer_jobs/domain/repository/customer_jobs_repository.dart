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
}
