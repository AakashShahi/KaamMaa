import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_view_model.dart';

void main() {
  group('OnboardingViewModel Tests', () {
    blocTest<OnboardingViewModel, OnboardingState>(
      'pageChanged emits correct state when index is not last',
      build: () => OnboardingViewModel(),
      act: (cubit) => cubit.pageChanged(1),
      expect:
          () => [const OnboardingInProgress(currentPage: 1, isLastPage: false)],
      tearDown: () {},
    );
  });
}
