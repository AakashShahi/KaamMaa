import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/accept_requested_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_requested_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/reject_requested_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRequestedJobsUsecase extends Mock
    implements GetRequestedJobsUsecase {}

class MockAcceptRequestedJobUsecase extends Mock
    implements AcceptRequestedJobUsecase {}

class MockRejectRequestedJobUsecase extends Mock
    implements RejectRequestedJobUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockGetRequestedJobsUsecase mockGetRequestedJobsUsecase;
  late MockAcceptRequestedJobUsecase mockAcceptRequestedJobUsecase;
  late MockRejectRequestedJobUsecase mockRejectRequestedJobUsecase;
  late CustomerRequestedJobsViewModel viewModel;

  setUpAll(() {
    // Register fallback values for custom types used in mocks
    registerFallbackValue(const AcceptRequestParams(jobId: '', workerId: ''));
    registerFallbackValue(const RejectJobParams(jobId: ''));
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockGetRequestedJobsUsecase = MockGetRequestedJobsUsecase();
    mockAcceptRequestedJobUsecase = MockAcceptRequestedJobUsecase();
    mockRejectRequestedJobUsecase = MockRejectRequestedJobUsecase();
    viewModel = CustomerRequestedJobsViewModel(
      getRequestedJobsUsecase: mockGetRequestedJobsUsecase,
      acceptRequestedJobUsecase: mockAcceptRequestedJobUsecase,
      rejectRequestedJobUsecase: mockRejectRequestedJobUsecase,
    );
  });

  // Dummy data for testing
  const tCategory = CustomerCategoryEntity(category: 'Delivery');
  final tJobsList = [
    const CustomerJobsEntity(
      jobId: '1',
      description: 'Deliver package',
      location: 'A',
      date: '2025-01-01',
      time: '10:00',
      category: tCategory,
    ),
    const CustomerJobsEntity(
      jobId: '2',
      description: 'Deliver letter',
      location: 'B',
      date: '2025-01-02',
      time: '11:00',
      category: tCategory,
    ),
  ];
  final tFailure = ApiFailure(message: 'Server Error');

  group('CustomerRequestedJobsViewModel', () {
    test('initial state is CustomerRequestedJobsInitial', () {
      expect(viewModel.state, CustomerRequestedJobsInitial());
    });

    group('LoadCustomerRequestedJobs', () {
      blocTest<CustomerRequestedJobsViewModel, CustomerRequestedJobsState>(
        'emits [Loading, Loaded] when successful',
        setUp:
            () => when(
              () => mockGetRequestedJobsUsecase(),
            ).thenAnswer((_) async => Right(tJobsList)),
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerRequestedJobs()),
        expect:
            () => [
              CustomerRequestedJobsLoading(),
              CustomerRequestedJobsLoaded(tJobsList),
            ],
      );

      blocTest<CustomerRequestedJobsViewModel, CustomerRequestedJobsState>(
        'emits [Loading, Error] when it fails',
        setUp:
            () => when(
              () => mockGetRequestedJobsUsecase(),
            ).thenAnswer((_) async => Left(tFailure)),
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerRequestedJobs()),
        expect:
            () => [
              CustomerRequestedJobsLoading(),
              CustomerRequestedJobsError(tFailure.message),
            ],
      );
    });
  });
}
