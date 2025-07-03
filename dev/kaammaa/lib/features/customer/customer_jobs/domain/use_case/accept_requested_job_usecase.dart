import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';

class AcceptRequestParams extends Equatable {
  final String jobId;
  final String workerId;

  const AcceptRequestParams({required this.jobId, required this.workerId});

  @override
  List<Object?> get props => [jobId, workerId];
}

class AcceptRequestedJobUsecase
    implements UsecaseWithParams<void, AcceptRequestParams> {
  final ICustomerJobsRepository _customerJobsRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  AcceptRequestedJobUsecase({
    required ICustomerJobsRepository customerJobsRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerJobsRepository = customerJobsRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(AcceptRequestParams params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _customerJobsRepository.acceptRequestedJob(
        tokenValue,
        params.workerId,
        params.jobId,
      ),
    );
  }
}
