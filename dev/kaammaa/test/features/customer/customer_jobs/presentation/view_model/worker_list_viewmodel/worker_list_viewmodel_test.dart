import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/assign_worker_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/use_case/get_matching_worker_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMatchingWorkerUsecase extends Mock
    implements GetMatchingWorkerUsecase {}

class MockAssignWorkerUsecase extends Mock implements AssignWorkerUsecase {}

class MockCustomerPostedJobsViewModel extends Mock
    implements CustomerPostedJobsViewModel {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockGetMatchingWorkerUsecase mockGetMatchingWorkerUsecase;
  late MockAssignWorkerUsecase mockAssignWorkerUsecase;
  late MockCustomerPostedJobsViewModel mockCustomerPostedJobsViewModel;
  late CustomerWorkerListViewModel viewModel;

  setUpAll(() {
    // Register fallback values for custom types used in mocks
    registerFallbackValue(const GetWorkerWithParams(category: ''));
    registerFallbackValue(const AssignWorkerParams(jobId: '', workerId: ''));
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(LoadCustomerPostedJobs());
  });

  setUp(() {
    mockGetMatchingWorkerUsecase = MockGetMatchingWorkerUsecase();
    mockAssignWorkerUsecase = MockAssignWorkerUsecase();
    mockCustomerPostedJobsViewModel = MockCustomerPostedJobsViewModel();

    // Register the mock with the service locator for the AssignWorker test
    serviceLocater.registerFactory<CustomerPostedJobsViewModel>(
      () => mockCustomerPostedJobsViewModel,
    );
    // Stub the mock's `add` method to prevent errors
    when(
      () => mockCustomerPostedJobsViewModel.add(any()),
    ).thenAnswer((_) async {});

    viewModel = CustomerWorkerListViewModel(
      getMatchingWorkerUsecase: mockGetMatchingWorkerUsecase,
      assignWorkerUsecase: mockAssignWorkerUsecase,
    );
  });

  tearDown(() {
    serviceLocater.reset();
  });

  // Dummy data
  const tCategory = CustomerCategoryEntity(category: 'Plumbing');
  const tWorkersList = [
    CustomerWorkerEntity(
      id: '1',
      username: 'worker1',
      email: 'w1@test.com',
      profession: tCategory,
      skills: [],
      isVerified: true,
      phone: '111',
    ),
  ];
  final tFailure = ApiFailure(message: 'Server Error');

  group('CustomerWorkerListViewModel', () {
    test('initial state is CustomerWorkerListInitial', () {
      expect(viewModel.state, CustomerWorkerListInitial());
    });

    group('LoadWorkersByCategory', () {
      blocTest<CustomerWorkerListViewModel, CustomerWorkerListState>(
        'emits [Loading, Loaded] when successful',
        setUp:
            () => when(
              () => mockGetMatchingWorkerUsecase(any()),
            ).thenAnswer((_) async => const Right(tWorkersList)),
        build: () => viewModel,
        act: (bloc) => bloc.add(const LoadWorkersByCategory('Plumbing')),
        expect:
            () => [
              CustomerWorkerListLoading(),
              const CustomerWorkerListLoaded(tWorkersList),
            ],
        verify:
            (_) => verify(
              () => mockGetMatchingWorkerUsecase(
                const GetWorkerWithParams(category: 'Plumbing'),
              ),
            ).called(1),
      );

      blocTest<CustomerWorkerListViewModel, CustomerWorkerListState>(
        'emits [Loading, Error] when it fails',
        setUp:
            () => when(
              () => mockGetMatchingWorkerUsecase(any()),
            ).thenAnswer((_) async => Left(tFailure)),
        build: () => viewModel,
        act: (bloc) => bloc.add(const LoadWorkersByCategory('Plumbing')),
        expect:
            () => [
              CustomerWorkerListLoading(),
              CustomerWorkerListError(tFailure.message),
            ],
        verify:
            (_) => verify(
              () => mockGetMatchingWorkerUsecase(
                const GetWorkerWithParams(category: 'Plumbing'),
              ),
            ).called(1),
      );
    });
  });
}
