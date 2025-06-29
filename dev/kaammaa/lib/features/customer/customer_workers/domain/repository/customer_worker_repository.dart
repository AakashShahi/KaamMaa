import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';

abstract interface class ICustomerWorkerRepository {
  Future<Either<Failure, List<CustomerWorkerEntity>>> getWorkersWithCategory(
    String? token,
    String category,
  );
}
