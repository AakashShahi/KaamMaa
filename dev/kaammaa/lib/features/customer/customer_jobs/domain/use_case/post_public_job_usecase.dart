import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';

class PostJobsWithParams extends Equatable {
  final String description;
  final String location;
  final CustomerCategoryEntity category;
  final String date;
  final String time;

  const PostJobsWithParams({
    required this.description,
    required this.location,
    required this.category,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [description, location, category, date, time];
}

class PostPublicJobUsecase
    implements UsecaseWithParams<void, PostJobsWithParams> {
  final ICustomerJobsRepository _customerJobsRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  PostPublicJobUsecase({
    required ICustomerJobsRepository customerJobsRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerJobsRepository = customerJobsRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(PostJobsWithParams params) async {
    final customerJobEntity = CustomerJobsEntity(
      category: params.category,
      description: params.description,
      location: params.location,
      date: params.date,
      time: params.time,
    );
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) =>
          _customerJobsRepository.postJob(tokenValue, customerJobEntity),
    );
  }
}
