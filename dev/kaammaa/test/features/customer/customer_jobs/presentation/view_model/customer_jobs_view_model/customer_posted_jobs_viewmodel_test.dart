import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/delete_posted_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_all_public_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllPublicJobsUsecase extends Mock
    implements GetAllPublicJobsUsecase {}

class MockDeletePostedJobUsecase extends Mock
    implements DeletePostedJobUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockGetAllPublicJobsUsecase mockGetAllPublicJobsUsecase;
  late MockDeletePostedJobUsecase mockDeletePostedJobUsecase;
  late CustomerPostedJobsViewModel viewModel;

  setUpAll(() {
    // Register fallback values for custom types used in mocks
    registerFallbackValue(const DeletePostedJobParams(jobId: ''));
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockGetAllPublicJobsUsecase = MockGetAllPublicJobsUsecase();
    mockDeletePostedJobUsecase = MockDeletePostedJobUsecase();
    viewModel = CustomerPostedJobsViewModel(
      mockGetAllPublicJobsUsecase,
      mockDeletePostedJobUsecase,
    );
  });

  // Dummy data for testing
  const tCategory = CustomerCategoryEntity(category: 'Home Repair');
  final tJobsList = [
    const CustomerJobsEntity(
      jobId: '1',
      description: 'Fix sink',
      location: 'Kitchen',
      date: '2025-08-02',
      time: '14:00',
      category: tCategory,
    ),
    const CustomerJobsEntity(
      jobId: '2',
      description: 'Paint wall',
      location: 'Living Room',
      date: '2025-08-03',
      time: '15:00',
      category: tCategory,
    ),
  ];
  final tFailure = ApiFailure(message: 'Server Error');

  group('CustomerPostedJobsViewModel', () {
    test('initial state is CustomerPostedJobsInitial', () {
      expect(viewModel.state, CustomerPostedJobsInitial());
    });

    group('LoadCustomerPostedJobs', () {
      blocTest<CustomerPostedJobsViewModel, CustomerPostedJobsState>(
        'emits [Loading, Loaded] when successful',
        setUp: () {
          when(
            () => mockGetAllPublicJobsUsecase(),
          ).thenAnswer((_) async => Right(tJobsList));
        },
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerPostedJobs()),
        expect:
            () => [
              CustomerPostedJobsLoading(),
              CustomerPostedJobsLoaded(tJobsList),
            ],
        verify: (_) => verify(() => mockGetAllPublicJobsUsecase()).called(1),
      );

      blocTest<CustomerPostedJobsViewModel, CustomerPostedJobsState>(
        'emits [Loading, Error] when it fails',
        setUp: () {
          when(
            () => mockGetAllPublicJobsUsecase(),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadCustomerPostedJobs()),
        expect:
            () => [
              CustomerPostedJobsLoading(),
              CustomerPostedJobsError(tFailure.message),
            ],
        verify: (_) => verify(() => mockGetAllPublicJobsUsecase()).called(1),
      );
    });
  });
}
