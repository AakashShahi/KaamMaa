import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

abstract class CustomerProfileState {}

class CustomerProfileInitial extends CustomerProfileState {}

class CustomerProfileLoading extends CustomerProfileState {}

class CustomerProfileLoaded extends CustomerProfileState {
  final AuthEntity user;
  CustomerProfileLoaded(this.user);
}

class CustomerProfileError extends CustomerProfileState {
  final Failure failure;
  CustomerProfileError(this.failure);
}
