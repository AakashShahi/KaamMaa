import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_inprogress_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetInprogressJobUsecase extends Mock
    implements GetInprogressJobUsecase {}

void main() {
  // 2. Declare variables for the mock and the ViewModel
  late MockGetInprogressJobUsecase mockGetInprogressJobUsecase;
  late CustomerInProgressJobsViewModel viewModel;

  // 3. Instantiate mocks and the ViewModel before each test
  setUp(() {
    mockGetInprogressJobUsecase = MockGetInprogressJobUsecase();
    viewModel = CustomerInProgressJobsViewModel(mockGetInprogressJobUsecase);
  });

  // 4. Dummy data for testing
  const tCategory = CustomerCategoryEntity(category: 'Gardening');
  final tJobsList = [
    const CustomerJobsEntity(
      jobId: '1',
      description: 'Mow the lawn',
      location: 'Backyard',
      date: '2025-08-02',
      time: '02:30 PM',
      category: tCategory,
    ),
  ];
  final tFailure = ApiFailure(message: 'Could not fetch jobs');

  group('CustomerInProgressJobsViewModel', () {
    test('initial state is CustomerInProgressJobsInitial', () {
      expect(viewModel.state, CustomerInProgressJobsInitial());
    });

    blocTest<CustomerInProgressJobsViewModel, CustomerInProgressJobsState>(
      'emits [Loading, Loaded] when LoadCustomerInProgressJobs is successful',
      setUp: () {
        // Arrange: Stub the use case to return a successful list of jobs
        when(
          () => mockGetInprogressJobUsecase(),
        ).thenAnswer((_) async => Right(tJobsList));
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(LoadCustomerInProgressJobs()),
      expect:
          () => [
            CustomerInProgressJobsLoading(),
            CustomerInProgressJobsLoaded(jobs: tJobsList),
          ],
      verify: (_) {
        // Verify that the use case was called exactly once
        verify(() => mockGetInprogressJobUsecase()).called(1);
      },
    );

    blocTest<CustomerInProgressJobsViewModel, CustomerInProgressJobsState>(
      'emits [Loading, Error] when LoadCustomerInProgressJobs fails',
      setUp: () {
        // Arrange: Stub the use case to return a failure
        when(
          () => mockGetInprogressJobUsecase(),
        ).thenAnswer((_) async => Left(tFailure));
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(LoadCustomerInProgressJobs()),
      expect:
          () => [
            CustomerInProgressJobsLoading(),
            CustomerInProgressJobsError(message: tFailure.message),
          ],
      verify: (_) {
        verify(() => mockGetInprogressJobUsecase()).called(1);
      },
    );
  });
}
