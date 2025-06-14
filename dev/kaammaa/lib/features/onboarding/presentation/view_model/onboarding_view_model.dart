import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:kaammaa/features/selection/presentation/view/selection_view.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';

class OnboardingViewModel extends Cubit<OnboardingState> {
  static const int _totalPages = 3;
  final PageController pageController = PageController();

  OnboardingViewModel()
    : super(const OnboardingInProgress(currentPage: 0, isLastPage: false));

  void pageChanged(int index) {
    final bool isLast = index == _totalPages - 1;
    emit(OnboardingInProgress(currentPage: index, isLastPage: isLast));
  }

  Future<void> nextPage() async {
    if (state is OnboardingInProgress) {
      final currentPage = (state as OnboardingInProgress).currentPage;
      if (currentPage < _totalPages - 1) {
        await pageController.animateToPage(
          currentPage + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        pageChanged(currentPage + 1);
      }
    }
  }

  Future<void> skipToLastPage() async {
    pageController.jumpToPage(_totalPages - 1);
    pageChanged(_totalPages - 1);
  }

  void completeOnboarding(BuildContext context) {
    emit(OnboardingCompleted());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: serviceLocater<SelectionViewModel>(),
              child: SelectionView(),
            ),
      ),
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
