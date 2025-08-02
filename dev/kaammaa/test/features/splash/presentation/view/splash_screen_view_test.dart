import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/splash/presentation/view/splash_screen_view.dart';
import 'package:kaammaa/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockSplashViewModel extends MockCubit<void> implements SplashViewModel {}

// Mock class for BuildContext
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockSplashViewModel mockSplashViewModel;

  // Register the mock BuildContext as a fallback value for verifying the init() call
  setUpAll(() {
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockSplashViewModel = MockSplashViewModel();
  });

  // Helper function to pump the widget with the necessary provider
  Future<void> pumpSplashScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SplashViewModel>.value(
          value: mockSplashViewModel,
          child: const SplashScreenView(),
        ),
      ),
    );
  }

  group('SplashScreenView', () {
    testWidgets('calls init on SplashViewModel when the screen is created', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockSplashViewModel.state).thenReturn(null);
      when(
        () => mockSplashViewModel.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSplashViewModel.init(any())).thenAnswer((_) async {});

      // Act
      await pumpSplashScreen(tester);

      // Assert
      verify(() => mockSplashViewModel.init(any())).called(1);
    });
  });
}
