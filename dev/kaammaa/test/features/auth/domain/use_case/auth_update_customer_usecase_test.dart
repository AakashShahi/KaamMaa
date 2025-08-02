import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';
import 'package:kaammaa/features/auth/domain/use_case/auth_update_customer_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class MockFile extends Mock implements File {} // Mock for the File object

void main() {
  // Declare variables for the mocks and the class under test
  late MockAuthRepository mockAuthRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late AuthUpdateCustomerUsecase usecase;
  late MockFile mockFile;

  // Set up the mocks and instantiate the use case before each test
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    mockFile = MockFile();
    usecase = AuthUpdateCustomerUsecase(
      authRepository: mockAuthRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  // Dummy data for testing
  const tToken = 'sample_auth_token';

  group('AuthUpdateCustomerUsecase', () {
    test('should call updateUser on the repository when successful', () async {
      // Arrange
      // **FIX**: Define test data inside the test where it's used.
      final tParams = UpdateCustomerParams(
        name: 'New Name',
        password: 'new_password',
        profilePic: mockFile,
      );

      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => const Right(tToken));
      when(
        () => mockAuthRepository.updateUser(any(), any(), any(), any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(null));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(
        () => mockAuthRepository.updateUser(
          tParams.name,
          tParams.password,
          tParams.profilePic,
          tToken,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return a failure when the repository fails', () async {
      // Arrange
      final tParams = UpdateCustomerParams(profilePic: mockFile);
      final tFailure = ApiFailure(message: 'Update Failed');

      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => const Right(tToken));
      when(
        () => mockAuthRepository.updateUser(any(), any(), any(), any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(
        () => mockAuthRepository.updateUser(
          tParams.name,
          tParams.password,
          tParams.profilePic,
          tToken,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return a failure when token retrieval fails', () async {
      // Arrange
      final tParams = UpdateCustomerParams(name: 'New Name');
      final tFailure = ApiFailure(message: 'Token not found');

      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verifyNever(
        () => mockAuthRepository.updateUser(any(), any(), any(), any()),
      );
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });
  });
}
