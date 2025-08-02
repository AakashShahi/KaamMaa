import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_state.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_post_jobs_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create Mocks for the BLoCs this View depends on
class MockCustomerPostJobsViewModel
    extends MockBloc<CustomerPostJobsEvent, CustomerPostJobsState>
    implements CustomerPostJobsViewModel {}

class MockCustomerDashboardViewModel
    extends MockBloc<CustomerDashboardEvent, CustomerDashboardState>
    implements CustomerDashboardViewModel {}

void main() {
  late MockCustomerPostJobsViewModel mockCustomerPostJobsViewModel;
  late MockCustomerDashboardViewModel mockCustomerDashboardViewModel;

  setUp(() {
    mockCustomerPostJobsViewModel = MockCustomerPostJobsViewModel();
    mockCustomerDashboardViewModel = MockCustomerDashboardViewModel();
  });

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          // A Scaffold is needed to show SnackBars
          body: MultiBlocProvider(
            providers: [
              BlocProvider<CustomerPostJobsViewModel>.value(
                value: mockCustomerPostJobsViewModel,
              ),
              BlocProvider<CustomerDashboardViewModel>.value(
                value: mockCustomerDashboardViewModel,
              ),
            ],
            child: const CustomerPostJobsView(),
          ),
        ),
      ),
    );
  }

  group('CustomerPostJobsView', () {
    testWidgets('shows loading indicator while categories are loading', (
      WidgetTester tester,
    ) async {
      // Arrange: Set the state to CategoriesLoading
      when(
        () => mockCustomerPostJobsViewModel.state,
      ).thenReturn(CategoriesLoading());

      // Act
      await pumpView(tester);

      // Assert
      expect(find.text('Post a Job'), findsOneWidget);
      // Check for the indicator inside the category field
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.byType(DropdownButtonFormField<CustomerCategoryEntity>),
        findsNothing,
      );
    });

    testWidgets(
      'shows loading indicator instead of button when posting a job',
      (WidgetTester tester) async {
        // Arrange: Set the state to CustomerPostJobsLoading
        when(
          () => mockCustomerPostJobsViewModel.state,
        ).thenReturn(CustomerPostJobsLoading());

        // Act
        await pumpView(tester);

        // Assert
        // The button should be replaced by a loading indicator
        expect(find.widgetWithText(ElevatedButton, 'Submit Job'), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );
  });
}
