import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/delete_failed_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_failed_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_failed_job_view_model/customer_failed_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_failed_job_view_model/customer_failed_job_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_failed_job_view_model/customer_failed_job_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFailedJobsUsecase extends Mock implements GetFailedJobsUsecase {}

class MockDeleteFailedJobsUsecase extends Mock
    implements DeleteFailedJobsUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockGetFailedJobsUsecase mockGetFailedJobsUsecase;
  late MockDeleteFailedJobsUsecase mockDeleteFailedJobsUsecase;
  late CustomerFailedJobsViewModel viewModel;

  setUpAll(() {
    // Register fallback values for custom types used in mocks
    registerFallbackValue(const DeleteFailedParams(jobId: ''));
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockGetFailedJobsUsecase = MockGetFailedJobsUsecase();
    mockDeleteFailedJobsUsecase = MockDeleteFailedJobsUsecase();
    viewModel = CustomerFailedJobsViewModel(
      getFailedJobsUsecase: mockGetFailedJobsUsecase,
      deleteFailedJobsUsecase: mockDeleteFailedJobsUsecase,
    );
  });

  // Dummy data for testing
  const tCategory = CustomerCategoryEntity(category: 'Repair');
  final tJobsList = [
    const CustomerJobsEntity(
      jobId: '1',
      description: 'Failed Job 1',
      location: 'A',
      date: '2025-01-01',
      time: '10:00',
      category: tCategory,
    ),
    const CustomerJobsEntity(
      jobId: '2',
      description: 'Failed Job 2',
      location: 'B',
      date: '2025-01-02',
      time: '11:00',
      category: tCategory,
    ),
  ];
  final tFailure = ApiFailure(message: 'Server Error');

  group('CustomerFailedJobsViewModel', () {
    test('initial state is CustomerFailedJobsInitial', () {
      expect(viewModel.state, CustomerFailedJobsInitial());
    });

    group('LoadCustomerFailedJobs', () {
      blocTest<CustomerFailedJobsViewModel, CustomerFailedJobsState>(
        'emits [Loading, Loaded] when successful',
        setUp: () {
          when(
            () => mockGetFailedJobsUsecase(),
          ).thenAnswer((_) async => Right(tJobsList));
        },
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerFailedJobs()),
        expect:
            () => [
              CustomerFailedJobsLoading(),
              CustomerFailedJobsLoaded(tJobsList),
            ],
        verify: (_) => verify(() => mockGetFailedJobsUsecase()).called(1),
      );

      blocTest<CustomerFailedJobsViewModel, CustomerFailedJobsState>(
        'emits [Loading, Error] when it fails',
        setUp: () {
          when(
            () => mockGetFailedJobsUsecase(),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerFailedJobs()),
        expect:
            () => [
              CustomerFailedJobsLoading(),
              CustomerFailedJobsError(tFailure.message),
            ],
        verify: (_) => verify(() => mockGetFailedJobsUsecase()).called(1),
      );
    });
  });
}
