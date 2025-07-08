import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/repository/customer_reviews_repository.dart';

class PostReviewParams extends Equatable {
  final String jobId;
  final String comment;
  final double rating;

  const PostReviewParams({
    required this.jobId,
    required this.comment,
    required this.rating,
  });

  @override
  List<Object?> get props => [jobId, comment, rating];
}

class PostReviewUsecase implements UsecaseWithParams<void, PostReviewParams> {
  final ICustomerReviewsRepository _customerReviewsRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  PostReviewUsecase({
    required ICustomerReviewsRepository customerReviewsRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerReviewsRepository = customerReviewsRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(PostReviewParams params) async {
    final customerReviewEntity = CustomerReviewsEntity(
      rating: params.rating,
      jobId: params.jobId,
      comment: params.comment,
    );
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _customerReviewsRepository.postReviews(
        tokenValue,
        customerReviewEntity,
      ),
    );
  }
}
