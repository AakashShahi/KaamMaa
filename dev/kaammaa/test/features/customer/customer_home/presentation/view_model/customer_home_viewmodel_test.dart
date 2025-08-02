import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_event.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_state.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_all_public_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_inprogress_job_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllPublicJobsUsecase extends Mock
    implements GetAllPublicJobsUsecase {}

class MockGetInprogressJobUsecase extends Mock
    implements GetInprogressJobUsecase {}

void main() {
  // 2. Declare variables for the mocks and the ViewModel
  late MockGetAllPublicJobsUsecase mockGetAllPublicJobsUsecase;
  late MockGetInprogressJobUsecase mockGetInprogressJobUsecase;
  late CustomerHomeViewModel customerHomeViewModel;

  // 3. Instantiate mocks before each test
  setUp(() {
    mockGetAllPublicJobsUsecase = MockGetAllPublicJobsUsecase();
    mockGetInprogressJobUsecase = MockGetInprogressJobUsecase();
    customerHomeViewModel = CustomerHomeViewModel(
      getAllPublicJobsUsecase: mockGetAllPublicJobsUsecase,
      getInprogressJobUsecase: mockGetInprogressJobUsecase,
    );
  });

  // 4. Dummy data for testing
  const dummyCategory = CustomerCategoryEntity(categoryName: 'Test Category');
  final List<CustomerJobsEntity> tPostedJobs = [
    const CustomerJobsEntity(
      jobId: 'p1',
      description: 'Posted Job 1',
      location: 'A',
      date: '2025-08-01',
      time: '10:00',
      category: dummyCategory,
    ),
    const CustomerJobsEntity(
      jobId: 'p2',
      description: 'Posted Job 2',
      location: 'B',
      date: '2025-08-02',
      time: '11:00',
      category: dummyCategory,
    ),
  ];
  final List<CustomerJobsEntity> tInProgressJobs = [
    const CustomerJobsEntity(
      jobId: 'i1',
      description: 'In-Progress Job 1',
      location: 'C',
      date: '2025-08-03',
      time: '12:00',
      category: dummyCategory,
    ),
  ];
  final tFailure = ApiFailure(message: 'Something went wrong');

  group('CustomerHomeViewModel', () {
    test('initial state is CustomerHomeInitial', () {
      expect(customerHomeViewModel.state, CustomerHomeInitial());
    });

    blocTest<CustomerHomeViewModel, CustomerHomeState>(
      'emits [Loading, Loaded] when both use cases succeed',
      setUp: () {
        // Arrange: Stub both use cases to return successful data
        when(
          () => mockGetAllPublicJobsUsecase(),
        ).thenAnswer((_) async => Right(tPostedJobs));
        when(
          () => mockGetInprogressJobUsecase(),
        ).thenAnswer((_) async => Right(tInProgressJobs));
      },
      build: () => customerHomeViewModel,
      act: (bloc) => bloc.add(LoadCustomerHomeData()),
      expect:
          () => <CustomerHomeState>[
            CustomerHomeLoading(),
            CustomerHomeLoaded(
              postedJobsCount: tPostedJobs.length, // Should be 2
              inProgressJobs: tInProgressJobs,
            ),
          ],
      verify: (_) {
        // Verify that both use cases were called exactly once
        verify(() => mockGetAllPublicJobsUsecase()).called(1);
        verify(() => mockGetInprogressJobUsecase()).called(1);
      },
    );

    blocTest<CustomerHomeViewModel, CustomerHomeState>(
      'emits [Loading, Error] when getAllPublicJobsUsecase fails',
      setUp: () {
        // Arrange: Stub the first use case to fail
        when(
          () => mockGetAllPublicJobsUsecase(),
        ).thenAnswer((_) async => Left(tFailure));
        // The second use case will still be called, so we stub it
        when(
          () => mockGetInprogressJobUsecase(),
        ).thenAnswer((_) async => Right(tInProgressJobs));
      },
      build: () => customerHomeViewModel,
      act: (bloc) => bloc.add(LoadCustomerHomeData()),
      expect:
          () => <CustomerHomeState>[
            CustomerHomeLoading(),
            CustomerHomeError("Failed to load posted jobs"),
          ],
      verify: (_) {
        verify(() => mockGetAllPublicJobsUsecase()).called(1);
        verify(() => mockGetInprogressJobUsecase()).called(1);
      },
    );

    blocTest<CustomerHomeViewModel, CustomerHomeState>(
      'emits [Loading, Error] when getInprogressJobUsecase fails',
      setUp: () {
        // Arrange: Stub the first use case to succeed and the second to fail
        when(
          () => mockGetAllPublicJobsUsecase(),
        ).thenAnswer((_) async => Right(tPostedJobs));
        when(
          () => mockGetInprogressJobUsecase(),
        ).thenAnswer((_) async => Left(tFailure));
      },
      build: () => customerHomeViewModel,
      act: (bloc) => bloc.add(LoadCustomerHomeData()),
      expect:
          () => <CustomerHomeState>[
            CustomerHomeLoading(),
            CustomerHomeError("Failed to load in-progress jobs"),
          ],
      verify: (_) {
        verify(() => mockGetAllPublicJobsUsecase()).called(1);
        verify(() => mockGetInprogressJobUsecase()).called(1);
      },
    );
  });
}
