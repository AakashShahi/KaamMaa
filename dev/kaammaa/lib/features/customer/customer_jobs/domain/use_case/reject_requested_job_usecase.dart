import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';

class RejectJobParams extends Equatable {
  final String jobId;

  const RejectJobParams({required this.jobId});

  @override
  List<Object?> get props => [jobId];
}

class RejectRequestedJobUsecase
    implements UsecaseWithParams<void, RejectJobParams> {
  final ICustomerJobsRepository _customerJobsRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  RejectRequestedJobUsecase({
    required ICustomerJobsRepository customerJobsRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerJobsRepository = customerJobsRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(RejectJobParams params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) =>
          _customerJobsRepository.rejectRequestedJob(tokenValue, params.jobId),
    );
  }
}
