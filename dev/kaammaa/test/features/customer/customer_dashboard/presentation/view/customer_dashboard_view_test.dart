import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view/customer_dashboard_view.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_state.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

// Mocks
class MockCustomerDashboardViewModel
    extends MockBloc<CustomerDashboardEvent, CustomerDashboardState>
    implements CustomerDashboardViewModel {}

class FakeCustomerDashboardEvent extends Fake
    implements CustomerDashboardEvent {}

void main() {
  late MockCustomerDashboardViewModel mockCustomerDashboardViewModel;

  const List<Widget> testWidgetList = [
    Center(child: Text('Home Tab')),
    Center(child: Text('Jobs Tab')),
    Center(child: Text('Create Job Tab')),
    Center(child: Text('Reviews Tab')),
    Center(child: Text('Profile Tab')),
  ];

  setUpAll(() {
    registerFallbackValue(FakeCustomerDashboardEvent());
  });

  setUp(() {
    mockCustomerDashboardViewModel = MockCustomerDashboardViewModel();
  });

  // This helper function pumps the widget with the necessary screen size and providers.
  Future<void> pumpDashboardView(WidgetTester tester) async {
    // This line is the critical fix for the RenderFlex overflow error.
    await tester.binding.setSurfaceSize(const Size(1080, 2340));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CustomerDashboardViewModel>.value(
          value: mockCustomerDashboardViewModel,
          child: const CustomerDashboardView(),
        ),
      ),
    );
  }

  group('CustomerDashboardView Widget Tests', () {
    testWidgets('renders UI with specific user data when state is updated', (
      WidgetTester tester,
    ) {
      // Mock network images to prevent network errors in tests
      return mockNetworkImagesFor(() async {
        final userState = CustomerDashboardState(
          selectedIndex: 0,
          widgetList: testWidgetList,
          userName: 'John Doe',
          userPhoto: 'aasets/logo/kaammaa.png',
        );

        when(() => mockCustomerDashboardViewModel.state).thenReturn(userState);
        when(
          () => mockCustomerDashboardViewModel.stream,
        ).thenAnswer((_) => const Stream.empty());

        await pumpDashboardView(tester);
        await tester.pumpAndSettle();

        expect(find.text('Hello, John Doe'), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is CircleAvatar &&
                widget.backgroundImage is NetworkImage,
          ),
          findsOneWidget,
        );
      });
    });
  });
}
