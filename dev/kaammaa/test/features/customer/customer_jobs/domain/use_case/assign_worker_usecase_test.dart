import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/assign_worker_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerJobsRepository extends Mock
    implements ICustomerJobsRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockCustomerJobsRepository mockCustomerJobsRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late AssignWorkerUsecase usecase;

  const tToken = 'test_token';
  const tJobId = 'job_001';
  const tWorkerId = 'worker_001';
  const tParams = AssignWorkerParams(jobId: tJobId, workerId: tWorkerId);
  final tFailure = ApiFailure(message: 'Failed to assign worker');

  setUp(() {
    mockCustomerJobsRepository = MockCustomerJobsRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = AssignWorkerUsecase(
      customerJobsRepository: mockCustomerJobsRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  group('AssignWorkerUsecase', () {
    test('should assign worker when token is retrieved successfully', () async {
      // Arrange
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => const Right(tToken));
      when(
        () => mockCustomerJobsRepository.assignWorkerToJob(any(), any(), any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(null));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(
        () => mockCustomerJobsRepository.assignWorkerToJob(
          tToken,
          tJobId,
          tWorkerId,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
      verifyNoMoreInteractions(mockCustomerJobsRepository);
    });

    test('should return failure when assignWorkerToJob fails', () async {
      // Arrange
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => const Right(tToken));
      when(
        () => mockCustomerJobsRepository.assignWorkerToJob(any(), any(), any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(
        () => mockCustomerJobsRepository.assignWorkerToJob(
          tToken,
          tJobId,
          tWorkerId,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
      verifyNoMoreInteractions(mockCustomerJobsRepository);
    });

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
        () => mockCustomerJobsRepository.assignWorkerToJob(any(), any(), any()),
      );
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });
  });
}
