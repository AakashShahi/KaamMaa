import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/repository/customer_reviews_repository.dart';

class DeleteReviewParams extends Equatable {
  final String reviewId;

  const DeleteReviewParams({required this.reviewId});

  @override
  List<Object?> get props => [reviewId];
}

class DeleteReviewUsecase
    implements UsecaseWithParams<void, DeleteReviewParams> {
  final ICustomerReviewsRepository _customerReviewsRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  DeleteReviewUsecase({
    required ICustomerReviewsRepository customerReviewsRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerReviewsRepository = customerReviewsRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(DeleteReviewParams params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _customerReviewsRepository.deleteOneReview(
        tokenValue,
        params.reviewId,
      ),
    );
  }
}
