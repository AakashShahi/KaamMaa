import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInProgress extends OnboardingState {
  final int currentPage;
  final bool isLastPage;

  const OnboardingInProgress({
    required this.currentPage,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [currentPage, isLastPage];
}

class OnboardingCompleted extends OnboardingState {}
