import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';

abstract interface class ICustomerReviewsRepository {
  Future<Either<Failure, void>> postReviews(
    String? token,
    CustomerReviewsEntity customerReviewsEntity,
  );
}
