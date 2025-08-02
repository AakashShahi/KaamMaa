import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/repository/customer_jobs_repository.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/reject_requested_job_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerJobsRepository extends Mock
    implements ICustomerJobsRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late RejectRequestedJobUsecase usecase;
  late MockCustomerJobsRepository mockRepository;
  late MockTokenSharedPrefs mockPrefs;

  setUp(() {
    mockRepository = MockCustomerJobsRepository();
    mockPrefs = MockTokenSharedPrefs();
    usecase = RejectRequestedJobUsecase(
      customerJobsRepository: mockRepository,
      tokenSharedPrefs: mockPrefs,
    );
  });

  const tJobId = 'job123';
  const tParams = RejectJobParams(jobId: tJobId);
  const tToken = 'fake-token';

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  test(
    'should call repository method with token and jobId when token is valid',
    () async {
      // arrange
      when(
        () => mockPrefs.getToken(),
      ).thenAnswer((_) async => const Right(tToken));

      when(
        () => mockRepository.rejectRequestedJob(tToken, tJobId),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, const Right(null));
      verify(() => mockPrefs.getToken()).called(1);
      verify(() => mockRepository.rejectRequestedJob(tToken, tJobId)).called(1);
      verifyNoMoreInteractions(mockPrefs);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return failure when token retrieval fails', () async {
    // arrange
    final failure = ApiFailure(message: 'Token error');

    when(() => mockPrefs.getToken()).thenAnswer((_) async => Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, Left(failure));
    verify(() => mockPrefs.getToken()).called(1);
    verifyZeroInteractions(mockRepository);
  });
}
