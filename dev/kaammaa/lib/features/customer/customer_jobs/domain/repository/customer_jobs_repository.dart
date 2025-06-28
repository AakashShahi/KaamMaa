import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract interface class ICustomerJobsRepository {
  /// Fetches public jobs for customers.
  ///
  /// Returns a list of [CustomerJob] objects.
  Future<Either<Failure, List<CustomerJobsEntity>>> getPublicJobs(
    String? token,
  );
}
