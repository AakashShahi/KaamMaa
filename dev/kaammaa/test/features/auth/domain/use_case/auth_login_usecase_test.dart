import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/use_case/auth_login_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'auth.mock.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late AuthLoginUsecase usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    registerFallbackValue(const LoginParams(identifier: '', password: ''));

    usecase = AuthLoginUsecase(
      authRepository: mockAuthRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  test('✅ should return token and save it when login succeeds', () async {
    // Arrange
    const loginParams = LoginParams(
      identifier: 'aakash',
      password: 'aakash123',
    );
    const token = 'abc123token';

    // Using mocktail: use 'when(() => ...)' with a lambda, and matchers for args
    when(
      () => mockAuthRepository.loginUser('aakash', 'aakash123'),
    ).thenAnswer((_) async => const Right(token));

    when(
      () => mockTokenSharedPrefs.saveToken(token),
    ).thenAnswer((_) async => Right<Failure, void>(null));

    // Act
    final result = await usecase(loginParams);

    // Assert
    expect(result, const Right(token));
    verify(() => mockAuthRepository.loginUser('aakash', 'aakash123')).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(token)).called(1);
  });
}
