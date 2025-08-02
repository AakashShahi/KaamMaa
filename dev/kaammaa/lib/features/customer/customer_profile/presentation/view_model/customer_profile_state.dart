import 'package:equatable/equatable.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

abstract class CustomerProfileState extends Equatable {
  const CustomerProfileState();

  @override
  List<Object?> get props => [];
}

class CustomerProfileInitial extends CustomerProfileState {}

class CustomerProfileLoading extends CustomerProfileState {}

class CustomerProfileLoaded extends CustomerProfileState {
  final AuthEntity user;
  const CustomerProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class CustomerProfileError extends CustomerProfileState {
  final Failure failure;
  const CustomerProfileError(this.failure);

  @override
  List<Object?> get props => [failure];
}
