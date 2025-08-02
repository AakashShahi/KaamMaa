import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';
import 'package:kaammaa/features/auth/domain/use_case/get_current_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  // 2. Declare variables for the mocks and the class under test
  late MockAuthRepository mockAuthRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late GetCurrentUserUsecase usecase;

  // 3. Set up the mocks and instantiate the use case before each test
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = GetCurrentUserUsecase(
      authRepository: mockAuthRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  // 4. Create dummy data for testing
  const tToken = 'sample_auth_token';
  const tAuthEntity = AuthEntity(
    userId: '1',
    name: 'Test User',
    username: 'testuser',
    email: 'test@user.com',
    password: 'password',
    role: 'customer',
    phone: '9876543210',
  );

  group('GetCurrentUserUsecase', () {
    test(
      'should get user from the repository when token retrieval is successful',
      () async {
        // Arrange: Stub the successful responses from dependencies
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));
        when(
          () => mockAuthRepository.getCurrentUser(tToken),
        ).thenAnswer((_) async => const Right(tAuthEntity));

        // Act: Call the use case
        final result = await usecase();

        // Assert: Check if the result is the expected AuthEntity
        expect(result, const Right(tAuthEntity));

        // Verify that the correct methods were called on the mocks
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(() => mockAuthRepository.getCurrentUser(tToken)).called(1);

        // Ensure no other methods were called
        verifyNoMoreInteractions(mockTokenSharedPrefs);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('should return a failure when repository fails to get user', () async {
      // Arrange: Stub a failure from the auth repository
      final tFailure = ApiFailure(message: 'Server error');
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => const Right(tToken));
      when(
        () => mockAuthRepository.getCurrentUser(tToken),
      ).thenAnswer((_) async => Left(tFailure));

      // Act: Call the use case
      final result = await usecase();

      // Assert: Check if the result is the expected Failure
      expect(result, Left(tFailure));

      // Verify that the correct methods were called
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(() => mockAuthRepository.getCurrentUser(tToken)).called(1);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return a failure when token retrieval fails', () async {
      // Arrange: Stub a failure from shared preferences
      final tFailure = ApiFailure(message: 'Cache error');
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act: Call the use case
      final result = await usecase();

      // Assert: Check if the result is the expected Failure
      expect(result, Left(tFailure));

      // Verify that only getToken was called
      verify(() => mockTokenSharedPrefs.getToken()).called(1);

      // **Crucially**, verify that the repository was NEVER called
      verifyNever(() => mockAuthRepository.getCurrentUser(any()));
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });
  });
}
