import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/repository/customer_worker_repository.dart';

class GetWorkerWithParams extends Equatable {
  final String category;

  const GetWorkerWithParams({required this.category});

  @override
  List<Object?> get props => [category];
}

class GetMatchingWorkerUsecase
    implements
        UsecaseWithParams<List<CustomerWorkerEntity>, GetWorkerWithParams> {
  final ICustomerWorkerRepository _customerWorkerRepository;
  final TokenSharedPrefs _tokenSharedPrefs;
  GetMatchingWorkerUsecase({
    required ICustomerWorkerRepository customerWorkerRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerWorkerRepository = customerWorkerRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, List<CustomerWorkerEntity>>> call(
    GetWorkerWithParams params,
  ) async {
    final String category = params.category;
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _customerWorkerRepository.getWorkersWithCategory(
        tokenValue,
        category,
      ),
    );
  }
}
