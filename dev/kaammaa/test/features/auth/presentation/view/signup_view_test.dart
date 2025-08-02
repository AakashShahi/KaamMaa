import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/common/kaammaa_loading_overlay.dart';
import 'package:kaammaa/features/auth/presentation/view/signup_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_state.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockSignupViewModel extends MockBloc<SignupEvent, SignupState>
    implements SignupViewModel {}

class MockSelectionViewModel extends MockBloc<dynamic, SelectionState>
    implements SelectionViewModel {}

// Fallback registration for custom events
class FakeSignupEvent extends Fake implements SignupEvent {}

void main() {
  late MockSignupViewModel mockSignupViewModel;
  late MockSelectionViewModel mockSelectionViewModel;

  setUpAll(() {
    registerFallbackValue(FakeSignupEvent());
  });

  setUp(() {
    mockSignupViewModel = MockSignupViewModel();
    mockSelectionViewModel = MockSelectionViewModel();
  });

  // Helper function to pump the widget with necessary BLoC providers
  Future<void> pumpSignupView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SignupViewModel>.value(value: mockSignupViewModel),
            BlocProvider<SelectionViewModel>.value(
              value: mockSelectionViewModel,
            ),
          ],
          child: Signupview(),
        ),
      ),
    );
  }

  group('Signupview', () {
    testWidgets('renders all text fields and sign-up button', (
      WidgetTester tester,
    ) async {
      // Arrange: Set up the initial states for both BLoCs
      when(
        () => mockSignupViewModel.state,
      ).thenReturn(const SignupState.initial());
      when(
        () => mockSelectionViewModel.state,
      ).thenReturn(const SelectionState(selectedType: 'customer'));

      // Act
      await pumpSignupView(tester);

      // Assert
      expect(find.text('Register to new account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.widgetWithText(ElevatedButton, 'Sign-Up'), findsOneWidget);
    });

    testWidgets(
      'shows validation errors when sign-up is tapped with empty fields',
      (WidgetTester tester) async {
        // Arrange
        when(
          () => mockSignupViewModel.state,
        ).thenReturn(const SignupState.initial());
        when(
          () => mockSelectionViewModel.state,
        ).thenReturn(const SelectionState(selectedType: 'customer'));
        await pumpSignupView(tester);

        // Act: Tap the button without entering any text
        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign-Up'));
        await tester.pump(); // Rebuild to show validation messages

        // Assert
        expect(find.text('Please enter your username'), findsOneWidget);
        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Please enter your phone number'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);
        // Verify that no signup event was sent
        verifyNever(
          () => mockSignupViewModel.add(any(that: isA<SignupUserEvent>())),
        );
      },
    );

    testWidgets('shows loading overlay when state is loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        () => mockSignupViewModel.state,
      ).thenReturn(const SignupState(isLoading: true, isSuccess: false));
      when(
        () => mockSelectionViewModel.state,
      ).thenReturn(const SelectionState(selectedType: 'customer'));

      // Act
      await pumpSignupView(tester);

      // Assert
      // Check that the loading overlay is active
      expect(
        find.byWidgetPredicate(
          (widget) => widget is KaammaaLoadingOverlay && widget.isLoading,
        ),
        findsOneWidget,
      );
    });
  });
}
