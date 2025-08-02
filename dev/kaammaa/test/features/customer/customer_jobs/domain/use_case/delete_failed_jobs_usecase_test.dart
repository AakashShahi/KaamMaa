import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/delete_failed_jobs_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerJobsRepository extends Mock
    implements ICustomerJobsRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockCustomerJobsRepository mockCustomerJobsRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late DeleteFailedJobsUsecase usecase;

  const tToken = 'test_token';
  const tJobId = 'failed_job_001';
  const tParams = DeleteFailedParams(jobId: tJobId);
  final tFailure = ApiFailure(message: 'Failed to delete job');

  setUp(() {
    mockCustomerJobsRepository = MockCustomerJobsRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = DeleteFailedJobsUsecase(
      customerJobsRepository: mockCustomerJobsRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  group('DeleteFailedJobsUsecase', () {
    test(
      'should delete failed job when token is retrieved successfully',
      () async {
        // Arrange
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        when(
          () => mockCustomerJobsRepository.deleteFailedJob(any(), any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Right(null));
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockCustomerJobsRepository.deleteFailedJob(tToken, tJobId),
        ).called(1);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockCustomerJobsRepository);
      },
    );

    test(
      'should return failure when repository fails to delete failed job',
      () async {
        // Arrange
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        when(
          () => mockCustomerJobsRepository.deleteFailedJob(any(), any()),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockCustomerJobsRepository.deleteFailedJob(tToken, tJobId),
        ).called(1);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockCustomerJobsRepository);
      },
    );

    test('should return failure when token retrieval fails', () async {
      // Arrange
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verifyNever(
        () => mockCustomerJobsRepository.deleteFailedJob(any(), any()),
      );
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });
  });
}
