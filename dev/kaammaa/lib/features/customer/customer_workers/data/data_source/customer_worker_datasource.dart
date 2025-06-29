import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';

abstract interface class ICustomerWorkerDatasource {
  Future<List<CustomerWorkerEntity>> getWorkersWithCategory(
    String? token,
    String category,
  );
}
