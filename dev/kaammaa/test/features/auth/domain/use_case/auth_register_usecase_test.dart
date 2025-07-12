import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/use_case/auth_register_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'auth.mock.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthRegisterUsecase usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();

    // Register fallback value for AuthEntity, if needed by mocktail
    registerFallbackValue(
      AuthEntity(username: '', email: '', password: '', role: '', phone: ''),
    );

    usecase = AuthRegisterUsecase(authRepository: mockAuthRepository);
  });

  test(
    '✅ should call registerUser and return Right(void) when registration succeeds',
    () async {
      // Arrange
      const params = RegisterUserParams(
        username: 'aakash',
        email: 'aakash@example.com',
        password: 'password123',
        role: 'user',
        phone: '1234567890',
      );

      when(
        () => mockAuthRepository.registerUser(any()),
      ).thenAnswer((_) async => const Right(null)); // success with void result

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.registerUser(any())).called(1);
    },
  );
}
