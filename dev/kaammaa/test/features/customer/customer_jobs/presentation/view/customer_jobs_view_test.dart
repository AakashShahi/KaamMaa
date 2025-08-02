import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_view_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_failed_job_view_model/customer_failed_job_view_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerPostedJobsViewModel extends Mock
    implements CustomerPostedJobsViewModel {}

class MockCustomerAssignedJobsViewModel extends Mock
    implements CustomerAssignedJobsViewModel {}

class MockCustomerInProgressJobsViewModel extends Mock
    implements CustomerInProgressJobsViewModel {}

class MockCustomerRequestedJobsViewModel extends Mock
    implements CustomerRequestedJobsViewModel {}

class MockCustomerFailedJobsViewModel extends Mock
    implements CustomerFailedJobsViewModel {}

void main() {
  late MockCustomerPostedJobsViewModel postedJobsViewModel;
  late MockCustomerAssignedJobsViewModel assignedJobsViewModel;
  late MockCustomerInProgressJobsViewModel inProgressJobsViewModel;
  late MockCustomerRequestedJobsViewModel requestedJobsViewModel;
  late MockCustomerFailedJobsViewModel failedJobsViewModel;

  setUp(() {
    postedJobsViewModel = MockCustomerPostedJobsViewModel();
    assignedJobsViewModel = MockCustomerAssignedJobsViewModel();
    inProgressJobsViewModel = MockCustomerInProgressJobsViewModel();
    requestedJobsViewModel = MockCustomerRequestedJobsViewModel();
    failedJobsViewModel = MockCustomerFailedJobsViewModel();

    // You can stub any methods/events if needed
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: Scaffold(
        body: DefaultTabController(
          length: 5,
          initialIndex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The same TabBar as your widget
              Container(
                color: Colors.grey[200],
                child: TabBar(
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Posted"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Assigned"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("In Progress"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Requested"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Failed"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocProvider<CustomerPostedJobsViewModel>.value(
                      value: postedJobsViewModel,
                      child: Container(
                        key: const Key('PostedJobs'),
                      ), // simple placeholder
                    ),
                    BlocProvider<CustomerAssignedJobsViewModel>.value(
                      value: assignedJobsViewModel,
                      child: Container(key: const Key('AssignedJobs')),
                    ),
                    BlocProvider<CustomerInProgressJobsViewModel>.value(
                      value: inProgressJobsViewModel,
                      child: Container(key: const Key('InProgressJobs')),
                    ),
                    BlocProvider<CustomerRequestedJobsViewModel>.value(
                      value: requestedJobsViewModel,
                      child: Container(key: const Key('RequestedJobs')),
                    ),
                    BlocProvider<CustomerFailedJobsViewModel>.value(
                      value: failedJobsViewModel,
                      child: Container(key: const Key('FailedJobs')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('tabs show correct labels and initial tab is In Progress', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Posted'), findsOneWidget);
    expect(find.text('Assigned'), findsOneWidget);
    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('Requested'), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);

    final defaultTabController = tester.widget<DefaultTabController>(
      find.byType(DefaultTabController),
    );
    expect(defaultTabController.initialIndex, 2);
  });

  testWidgets('tab switching works', (tester) async {
    await tester.pumpWidget(buildTestableWidget());

    await tester.tap(find.text('Posted'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('PostedJobs')), findsOneWidget);
  });
}
