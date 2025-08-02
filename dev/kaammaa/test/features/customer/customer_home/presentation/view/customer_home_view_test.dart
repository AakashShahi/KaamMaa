import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_state.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view/customer_home_view.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_event.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_state.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create Mocks for the BLoCs this View depends on
class MockCustomerHomeViewModel
    extends MockBloc<CustomerHomeEvent, CustomerHomeState>
    implements CustomerHomeViewModel {}

class MockCustomerDashboardViewModel
    extends MockBloc<CustomerDashboardEvent, CustomerDashboardState>
    implements CustomerDashboardViewModel {}

// Fallback registration for custom events
class FakeCustomerHomeEvent extends Fake implements CustomerHomeEvent {}

class FakeCustomerDashboardEvent extends Fake
    implements CustomerDashboardEvent {}

void main() {
  late MockCustomerHomeViewModel mockCustomerHomeViewModel;
  late MockCustomerDashboardViewModel mockCustomerDashboardViewModel;

  // 2. Set up mocks before each test
  setUpAll(() {
    // Register fallbacks once for all tests
    registerFallbackValue(FakeCustomerHomeEvent());
    registerFallbackValue(FakeCustomerDashboardEvent());
  });

  setUp(() {
    mockCustomerHomeViewModel = MockCustomerHomeViewModel();
    mockCustomerDashboardViewModel = MockCustomerDashboardViewModel();
  });

  // 3. Create a helper function to pump the widget with necessary providers
  Future<void> pumpCustomerHomeView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CustomerHomeViewModel>.value(
              value: mockCustomerHomeViewModel,
            ),
            BlocProvider<CustomerDashboardViewModel>.value(
              value: mockCustomerDashboardViewModel,
            ),
          ],
          child: const CustomerHomeView(),
        ),
      ),
    );
  }

  group('CustomerHomeView', () {
    testWidgets(
      'renders CircularProgressIndicator when state is CustomerHomeLoading',
      (WidgetTester tester) async {
        // Arrange
        when(
          () => mockCustomerHomeViewModel.state,
        ).thenReturn(CustomerHomeLoading());

        // Act
        await pumpCustomerHomeView(tester);

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('renders error message when state is CustomerHomeError', (
      WidgetTester tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load data';
      // **FIX**: Removed 'const' because the constructor is not const
      when(
        () => mockCustomerHomeViewModel.state,
      ).thenReturn(CustomerHomeError(errorMessage));

      // Act
      await pumpCustomerHomeView(tester);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets(
      'renders placeholder when state is CustomerHomeLoaded but inProgressJobs is empty',
      (WidgetTester tester) async {
        // Arrange
        // **FIX**: Removed 'const'
        final loadedState = CustomerHomeLoaded(
          postedJobsCount: 2,
          inProgressJobs: [], // Empty list
        );
        whenListen(
          mockCustomerHomeViewModel,
          Stream.value(loadedState),
          initialState: CustomerHomeInitial(),
        );

        // Act
        await pumpCustomerHomeView(tester);
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No In-Progress Jobs Found'), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      },
    );

    testWidgets('tapping "View All" fires ChangeCustomerTabEvent', (
      WidgetTester tester,
    ) async {
      // Arrange
      // **FIX**: Removed 'const'
      final loadedState = CustomerHomeLoaded(
        postedJobsCount: 5,
        inProgressJobs: [],
      );
      whenListen(
        mockCustomerHomeViewModel,
        Stream.value(loadedState),
        initialState: CustomerHomeInitial(),
      );

      await pumpCustomerHomeView(tester);
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('View All'));

      // Assert
      verify(
        () => mockCustomerDashboardViewModel.add(
          any(that: isA<ChangeCustomerTabEvent>()),
        ),
      ).called(1);
    });
  });
}
