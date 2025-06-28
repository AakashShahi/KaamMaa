import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

abstract interface class ICustomerJobsDatasource {
  Future<List<CustomerJobsEntity>> getPublicJobs(String? token);
}
