import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/cancel_assigned_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_assigned_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAssignedJobUsecase extends Mock implements GetAssignedJobUsecase {}

class MockCancelAssignedJobUsecase extends Mock
    implements CancelAssignedJobUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockGetAssignedJobUsecase mockGetAssignedJobUsecase;
  late MockCancelAssignedJobUsecase mockCancelAssignedJobUsecase;
  late CustomerAssignedJobsViewModel viewModel;

  setUpAll(() {
    // Register fallback values for custom types used in mocks
    registerFallbackValue(const CancelParams(jobId: ''));
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockGetAssignedJobUsecase = MockGetAssignedJobUsecase();
    mockCancelAssignedJobUsecase = MockCancelAssignedJobUsecase();
    viewModel = CustomerAssignedJobsViewModel(
      getAssignedJobUsecase: mockGetAssignedJobUsecase,
      cancelAssignedJobUsecase: mockCancelAssignedJobUsecase,
    );
  });

  // Dummy data for testing
  const tCategory = CustomerCategoryEntity(category: 'Cleaning');
  final tJobsList = [
    const CustomerJobsEntity(
      jobId: '1',
      description: 'Job 1',
      location: 'A',
      date: '2025-01-01',
      time: '10:00',
      category: tCategory,
    ),
    const CustomerJobsEntity(
      jobId: '2',
      description: 'Job 2',
      location: 'B',
      date: '2025-01-02',
      time: '11:00',
      category: tCategory,
    ),
  ];
  final tFailure = ApiFailure(message: 'Server Error');

  group('CustomerAssignedJobsViewModel', () {
    test('initial state is CustomerAssignedJobsInitial', () {
      expect(viewModel.state, CustomerAssignedJobsInitial());
    });

    group('LoadCustomerAssignedJobs', () {
      blocTest<CustomerAssignedJobsViewModel, CustomerAssignedJobsState>(
        'emits [Loading, Loaded] when successful',
        setUp: () {
          when(
            () => mockGetAssignedJobUsecase(),
          ).thenAnswer((_) async => Right(tJobsList));
        },
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerAssignedJobs()),
        expect:
            () => [
              CustomerAssignedJobsLoading(),
              CustomerAssignedJobsLoaded(tJobsList),
            ],
        verify: (_) => verify(() => mockGetAssignedJobUsecase()).called(1),
      );

      blocTest<CustomerAssignedJobsViewModel, CustomerAssignedJobsState>(
        'emits [Loading, Error] when fails',
        setUp: () {
          when(
            () => mockGetAssignedJobUsecase(),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerAssignedJobs()),
        expect:
            () => [
              CustomerAssignedJobsLoading(),
              CustomerAssignedJobsError(tFailure.message),
            ],
        verify: (_) => verify(() => mockGetAssignedJobUsecase()).called(1),
      );
    });
  });
}
