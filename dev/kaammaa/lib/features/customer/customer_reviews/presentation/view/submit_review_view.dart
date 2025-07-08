import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_reviews_event.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_reviews_state.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_reviews_viewmodel.dart';

class SubmitReviewView extends StatefulWidget {
  final String jobId;

  const SubmitReviewView({super.key, required this.jobId});

  @override
  State<SubmitReviewView> createState() => _SubmitReviewViewState();
}

class _SubmitReviewViewState extends State<SubmitReviewView> {
  double _rating = 0;
  final _commentController = TextEditingController();

  void _submit() {
    final comment = _commentController.text.trim();

    if (_rating == 0) {
      AppFlushbar.show(
        context: context,
        message: "Please select a rating",
        backgroundColor: AppColors.error,
        icon: const Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    context.read<SubmitReviewViewModel>().add(
      SubmitReviewRequested(
        jobId: widget.jobId,
        rating: _rating,
        comment: comment,
        context: context, // pass context here
        onSuccess: () {
          // Optional additional logic on success, if needed
        },
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Review")),
      body: BlocListener<SubmitReviewViewModel, SubmitReviewState>(
        listener: (context, state) {
          if (state is SubmitReviewSuccess) {
            AppFlushbar.show(
              context: context,
              message: "Review submitted successfully!",
              backgroundColor: AppColors.success,
              icon: const Icon(Icons.check_circle, color: Colors.white),
            );
          } else if (state is SubmitReviewFailure) {
            AppFlushbar.show(
              context: context,
              message: state.message,
              backgroundColor: AppColors.error,
              icon: const Icon(Icons.error, color: Colors.white),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<SubmitReviewViewModel, SubmitReviewState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rate the Job",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 0.5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.orange),
                    onRatingUpdate: (rating) {
                      setState(() => _rating = rating);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Comment",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Write your feedback...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is SubmitReviewLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          state is SubmitReviewLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Submit Review",
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
