import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/kaammaa_loading_overlay.dart';
import 'package:kaammaa/features/auth/presentation/view/login_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

// Fallback registration for custom events
class FakeLoginEvent extends Fake implements LoginEvent {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  // 2. Set up the mock and register it with the service locator
  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    // CRITICAL: Register the mock so the view gets it from the service locator
    if (serviceLocater.isRegistered<LoginViewModel>()) {
      serviceLocater.unregister<LoginViewModel>();
    }
    serviceLocater.registerFactory<LoginViewModel>(() => mockLoginViewModel);
  });

  tearDown(() {
    serviceLocater.reset();
  });

  // 3. Helper function to pump the widget
  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Loginview()));
  }

  group('Loginview', () {
    testWidgets('renders initial UI elements correctly', (
      WidgetTester tester,
    ) async {
      // Arrange: Set the initial state for the BLoC
      when(
        () => mockLoginViewModel.state,
      ).thenReturn(const LoginState.initial());

      // Act
      await pumpLoginView(tester);

      // Assert
      expect(find.text('Login to your account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Sign-In'), findsOneWidget);
      expect(find.text('New to '), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('shows validation errors for empty fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        () => mockLoginViewModel.state,
      ).thenReturn(const LoginState.initial());
      await pumpLoginView(tester);

      // Act: Tap the sign-in button without entering text
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign-In'));
      await tester.pump(); // Allow the UI to rebuild with validation messages

      // Assert
      expect(find.text('Please enter your email or username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      // Verify that no login event was sent
      verifyNever(
        () => mockLoginViewModel.add(
          any(that: isA<LoginWithEmailAndPasswordEvent>()),
        ),
      );
    });

    testWidgets('toggles password visibility when icon is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        () => mockLoginViewModel.state,
      ).thenReturn(const LoginState.initial());
      await pumpLoginView(tester);

      // Assert: Initially password is obscure
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Act: Tap the visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Assert: Now password should be visible
      expect(find.byIcon(Icons.visibility_off), findsNothing);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets(
      'shows loading overlay and disables button when state is loading',
      (WidgetTester tester) async {
        // Arrange
        when(
          () => mockLoginViewModel.state,
        ).thenReturn(const LoginState(isLoading: true, isSuccess: false));
        await pumpLoginView(tester);

        // Assert
        // Check that the loading overlay is active
        expect(
          find.byWidgetPredicate(
            (widget) => widget is KaammaaLoadingOverlay && widget.isLoading,
          ),
          findsOneWidget,
        );

        // Check that the button is disabled
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNull);
      },
    );
  });
}
