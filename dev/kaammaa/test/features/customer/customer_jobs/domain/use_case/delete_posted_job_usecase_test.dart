import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/delete_posted_job_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerJobsRepository extends Mock
    implements ICustomerJobsRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockCustomerJobsRepository mockCustomerJobsRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late DeletePostedJobUsecase usecase;

  const tToken = 'sample_token';
  const tJobId = 'posted_job_001';
  const tParams = DeletePostedJobParams(jobId: tJobId);
  final tFailure = ApiFailure(message: 'Delete failed');

  setUp(() {
    mockCustomerJobsRepository = MockCustomerJobsRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = DeletePostedJobUsecase(
      customerJobsRepository: mockCustomerJobsRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  group('DeletePostedJobUsecase', () {
    test(
      'should delete posted job when token is successfully retrieved',
      () async {
        // Arrange
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        when(
          () => mockCustomerJobsRepository.deletePostedJob(any(), any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Right(null));
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockCustomerJobsRepository.deletePostedJob(tToken, tJobId),
        ).called(1);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockCustomerJobsRepository);
      },
    );

    test(
      'should return failure when deletePostedJob fails in repository',
      () async {
        // Arrange
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        when(
          () => mockCustomerJobsRepository.deletePostedJob(any(), any()),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockCustomerJobsRepository.deletePostedJob(tToken, tJobId),
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
        () => mockCustomerJobsRepository.deletePostedJob(any(), any()),
      );
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });
  });
}
