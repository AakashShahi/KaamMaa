import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';

abstract interface class ICustomerReviewsDatasource {
  Future<void> postReviews(
    String? token,
    CustomerReviewsEntity customerReviewsEntity,
  );

  Future<List<CustomerReviewsEntity>> getReviews(String? token);

  Future<void> deleteOneReview(String? token, String? reviewId);

  Future<void> deleteAllReview(String? token);
}
