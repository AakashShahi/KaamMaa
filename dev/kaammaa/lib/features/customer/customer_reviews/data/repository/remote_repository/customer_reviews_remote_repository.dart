import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_reviews/data/data_source/remote_data_source/customer_reviews_remote_datasource.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';
import 'package:kaammaa/features/customer/customer_reviews/domain/repository/customer_reviews_repository.dart';

class CustomerReviewsRemoteRepository implements ICustomerReviewsRepository {
  final CustomerReviewsRemoteDatasource _customerReviewsRemoteDatasource;

  CustomerReviewsRemoteRepository({
    required CustomerReviewsRemoteDatasource customerReviewsRemoteDatasource,
  }) : _customerReviewsRemoteDatasource = customerReviewsRemoteDatasource;

  @override
  Future<Either<Failure, void>> postReviews(
    String? token,
    CustomerReviewsEntity customerReviewsEntity,
  ) async {
    try {
      await _customerReviewsRemoteDatasource.postReviews(
        token,
        customerReviewsEntity,
      );
      return Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to post review: ${e.toString()}"),
      );
    }
  }
}
