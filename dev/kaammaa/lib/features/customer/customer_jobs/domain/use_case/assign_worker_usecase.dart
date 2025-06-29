import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';

class AssignWorkerParams extends Equatable {
  final String jobId;
  final String workerId;

  const AssignWorkerParams({required this.jobId, required this.workerId});

  @override
  List<Object?> get props => [jobId, workerId];
}

class AssignWorkerUsecase
    implements UsecaseWithParams<void, AssignWorkerParams> {
  final ICustomerJobsRepository _customerJobsRepository;
  final TokenSharedPrefs _tokenSharedPrefs;
  AssignWorkerUsecase({
    required ICustomerJobsRepository customerJobsRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerJobsRepository = customerJobsRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(AssignWorkerParams params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _customerJobsRepository.assignWorkerToJob(
        tokenValue,
        params.jobId,
        params.workerId,
      ),
    );
  }
}
