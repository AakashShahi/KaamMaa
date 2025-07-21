import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';

abstract interface class ICustomerReviewsRepository {
  Future<Either<Failure, void>> postReviews(
    String? token,
    CustomerReviewsEntity customerReviewsEntity,
  );

  Future<Either<Failure, List<CustomerReviewsEntity>>> getReviews(
    String? token,
  );

  Future<Either<Failure, void>> deleteOneReview(
    String? token,
    String? reviewId,
  );

  Future<Either<Failure, void>> deleteAllReview(String? token);
}
