import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/accept_requested_job_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerJobsRepository extends Mock
    implements ICustomerJobsRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  // 2. Declare variables for the mocks and the class under test
  late MockCustomerJobsRepository mockCustomerJobsRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late AcceptRequestedJobUsecase usecase;

  // 3. Set up the mocks and instantiate the use case before each test
  setUp(() {
    mockCustomerJobsRepository = MockCustomerJobsRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = AcceptRequestedJobUsecase(
      customerJobsRepository: mockCustomerJobsRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  // 4. Create dummy data for testing
  const tToken = 'sample_auth_token';
  const tJobId = 'job_123';
  const tWorkerId = 'worker_456';
  const tParams = AcceptRequestParams(jobId: tJobId, workerId: tWorkerId);
  final tFailure = ApiFailure(message: 'Server Error');

  group('AcceptRequestedJobUsecase', () {
    test(
      'should call repository to accept job when token is retrieved successfully',
      () async {
        // Arrange: Stub the successful responses from dependencies
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        // For a void return type, we return Right(null)
        when(
          () => mockCustomerJobsRepository.acceptRequestedJob(
            any(),
            any(),
            any(),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act: Call the use case
        final result = await usecase(tParams);

        // Assert: Check that the result is a success (Right<void>)
        expect(result, const Right(null));

        // Verify that the correct methods were called on the mocks with correct arguments
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockCustomerJobsRepository.acceptRequestedJob(
            tToken,
            tWorkerId,
            tJobId,
          ),
        ).called(1);

        // Ensure no other methods were called
        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockCustomerJobsRepository);
      },
    );

    test(
      'should return a failure when the repository fails to accept the job',
      () async {
        // Arrange: Stub a failure from the repository
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        when(
          () => mockCustomerJobsRepository.acceptRequestedJob(
            any(),
            any(),
            any(),
          ),
        ).thenAnswer((_) async => Left(tFailure));

        // Act: Call the use case
        final result = await usecase(tParams);

        // Assert: Check that the result is the expected Failure
        expect(result, Left(tFailure));

        // Verify that the correct methods were called
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockCustomerJobsRepository.acceptRequestedJob(
            tToken,
            tWorkerId,
            tJobId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockCustomerJobsRepository);
      },
    );

    test('should return a failure when token retrieval fails', () async {
      // Arrange: Stub a failure from shared preferences
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act: Call the use case
      final result = await usecase(tParams);

      // Assert: Check that the result is the expected Failure
      expect(result, Left(tFailure));

      // Verify that only getToken was called
      verify(() => mockTokenSharedPrefs.getToken()).called(1);

      // **Crucially**, verify that the repository was NEVER called
      verifyNever(
        () =>
            mockCustomerJobsRepository.acceptRequestedJob(any(), any(), any()),
      );
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });
  });
}
