import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/features/selection/presentation/view/selection_view.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_state.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockSelectionViewModel extends MockCubit<SelectionState>
    implements SelectionViewModel {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockSelectionViewModel mockSelectionViewModel;

  // 2. Set up mocks and register fallbacks
  setUpAll(() {
    // Required for verifying methods that take BuildContext as a parameter
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockSelectionViewModel = MockSelectionViewModel();

    // CRITICAL: Register the mock so the view gets it from the service locator
    if (serviceLocater.isRegistered<SelectionViewModel>()) {
      serviceLocater.unregister<SelectionViewModel>();
    }
    serviceLocater.registerFactory<SelectionViewModel>(
      () => mockSelectionViewModel,
    );
  });

  tearDown(() {
    serviceLocater.reset();
  });

  // Helper function to pump the widget
  Future<void> pumpSelectionView(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SelectionView()));
  }

  group('SelectionView', () {
    testWidgets('renders initial UI with Continue button disabled', (
      WidgetTester tester,
    ) async {
      // Arrange: Set the initial state where no type is selected
      when(
        () => mockSelectionViewModel.state,
      ).thenReturn(const SelectionState(selectedType: null));

      // Act
      await pumpSelectionView(tester);

      // Assert
      expect(find.text('Choose Your Type'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Check that the button is disabled
      final continueButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(continueButton.onPressed, isNull);
    });

    testWidgets('calls selectType("customer") when Customer card is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        () => mockSelectionViewModel.state,
      ).thenReturn(const SelectionState(selectedType: null));
      await pumpSelectionView(tester);

      // Act: Find the GestureDetector containing the customer image and tap it
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is GestureDetector &&
              widget.child is AnimatedContainer &&
              ((widget.child as AnimatedContainer).child as Image).image
                  is AssetImage &&
              (((widget.child as AnimatedContainer).child as Image).image
                          as AssetImage)
                      .assetName ==
                  'assets/logo/customer.png',
        ),
      );

      // Assert
      verify(() => mockSelectionViewModel.selectType('customer')).called(1);
    });

    testWidgets('enables Continue button when a type is selected', (
      WidgetTester tester,
    ) async {
      // Arrange: Set the state to have a selected type
      when(
        () => mockSelectionViewModel.state,
      ).thenReturn(const SelectionState(selectedType: 'worker'));

      // Act
      await pumpSelectionView(tester);

      // Assert
      // Check that the button is now enabled
      final continueButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(continueButton.onPressed, isNotNull);
    });
  });
}
