import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract interface class ICustomerJobsDatasource {
  Future<List<CustomerJobsEntity>> getPublicJobs(String? token);

  Future<void> postJob(String? token, CustomerJobsEntity customerJobsEntity);

  Future<void> assignWorkerToJob(String? token, String jobId, String workerId);

  Future<void> deletePostedJob(String? token, String? jobId);
}
