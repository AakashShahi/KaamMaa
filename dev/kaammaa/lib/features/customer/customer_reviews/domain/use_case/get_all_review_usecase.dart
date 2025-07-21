import 'package:dartz/dartz.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/repository/customer_reviews_repository.dart';

class GetAllReviewUsecase
    implements UsecaseWithoutParams<List<CustomerReviewsEntity>> {
  final ICustomerReviewsRepository _customerReviewsRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetAllReviewUsecase({
    required ICustomerReviewsRepository customerReviewsRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerReviewsRepository = customerReviewsRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, List<CustomerReviewsEntity>>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _customerReviewsRepository.getReviews(tokenValue),
    );
  }
}
