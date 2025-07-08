import 'package:kaammaa/features/customer/customer_reviews/domain/entity/customer_reviews_entity.dart';

abstract interface class ICustomerReviewsDatasource {
  Future<void> postReviews(
    String? token,
    CustomerReviewsEntity customerReviewsEntity,
  );
}
