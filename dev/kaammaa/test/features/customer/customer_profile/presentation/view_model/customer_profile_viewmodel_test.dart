import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/use_case/get_current_user_usecase.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_event.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_state.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

void main() {
  // 2. Declare variables for the mock and the ViewModel
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late CustomerProfileViewModel viewModel;

  // 3. Instantiate mocks and the ViewModel before each test
  setUp(() {
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    viewModel = CustomerProfileViewModel(mockGetCurrentUserUsecase);
  });

  // 4. Dummy data for testing
  const tAuthEntity = AuthEntity(
    userId: '1',
    name: 'Test User',
    username: 'testuser',
    email: 'test@user.com',
    password: 'password',
    role: 'customer',
    phone: '9876543210',
  );
  final tFailure = ApiFailure(message: 'Could not fetch profile');

  group('CustomerProfileViewModel', () {
    test('initial state is CustomerProfileInitial', () {
      expect(viewModel.state, CustomerProfileInitial());
    });

    blocTest<CustomerProfileViewModel, CustomerProfileState>(
      'emits [Loading, Loaded] when FetchCustomerProfileEvent is successful',
      setUp: () {
        // Arrange: Stub the use case to return a successful user entity
        when(
          () => mockGetCurrentUserUsecase(),
        ).thenAnswer((_) async => const Right(tAuthEntity));
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(FetchCustomerProfileEvent()),
      expect:
          () => [
            CustomerProfileLoading(),
            const CustomerProfileLoaded(tAuthEntity),
          ],
      verify: (_) {
        // Verify that the use case was called exactly once
        verify(() => mockGetCurrentUserUsecase()).called(1);
      },
    );

    blocTest<CustomerProfileViewModel, CustomerProfileState>(
      'emits [Loading, Error] when FetchCustomerProfileEvent fails',
      setUp: () {
        // Arrange: Stub the use case to return a failure
        when(
          () => mockGetCurrentUserUsecase(),
        ).thenAnswer((_) async => Left(tFailure));
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(FetchCustomerProfileEvent()),
      expect: () => [CustomerProfileLoading(), CustomerProfileError(tFailure)],
      verify: (_) {
        verify(() => mockGetCurrentUserUsecase()).called(1);
      },
    );
  });
}
