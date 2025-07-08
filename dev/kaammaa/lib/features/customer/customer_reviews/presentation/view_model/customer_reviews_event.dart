import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SubmitReviewEvent extends Equatable {
  const SubmitReviewEvent();

  @override
  List<Object?> get props => [];
}

class SubmitReviewRequested extends SubmitReviewEvent {
  final String jobId;
  final double rating;
  final String comment;
  final BuildContext context; // add this
  final VoidCallback? onSuccess;

  const SubmitReviewRequested({
    required this.jobId,
    required this.rating,
    required this.comment,
    required this.context, // required now
    this.onSuccess,
  });

  @override
  List<Object?> get props => [jobId, rating, comment];
}
