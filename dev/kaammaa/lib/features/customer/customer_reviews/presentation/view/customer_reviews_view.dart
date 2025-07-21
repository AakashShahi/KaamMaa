import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_event.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_state.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_viewmodel.dart';

class CustomerReviewsView extends StatelessWidget {
  const CustomerReviewsView({super.key});

  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime); // Removes time
  }

  @override
  Widget build(BuildContext context) {
    // Trigger event after widget is built
    Future.microtask(() {
      context.read<CustomerGetReviewsViewModel>().add(
        GetAllCustomerReviewsEvent(),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton.icon(
            onPressed: () {
              // TODO: Implement delete all
            },
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: const Text(
              "Delete All",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<
            CustomerGetReviewsViewModel,
            CustomerGetReviewsState
          >(
            builder: (context, state) {
              if (state is CustomerReviewsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CustomerReviewsLoaded) {
                if (state.reviews.isEmpty) {
                  return const Center(child: Text("No reviews found."));
                }

                return ListView.builder(
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Worker: ${review.workerId?.name ?? "N/A"}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    // TODO: Implement single delete
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text("Phone: ${review.workerId?.phone ?? "N/A"}"),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(5, (starIndex) {
                                final rating = review.rating;
                                return Icon(
                                  starIndex < rating
                                      ? Icons.star
                                      : starIndex < rating + 0.5
                                      ? Icons.star_half
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(height: 6),
                            Text("Comment: ${review.comment}"),
                            const SizedBox(height: 6),
                            Text("Date: ${review.createdAt?.substring(0, 10)}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is CustomerReviewsError) {
                return Center(child: Text("Error: ${state.failure.message}"));
              } else {
                return const Center(child: Text("Loading reviews..."));
              }
            },
          ),
        ),
      ],
    );
  }
}
