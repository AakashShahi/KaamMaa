import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;

  const SignupState({required this.isLoading, required this.isSuccess});

  const SignupState.initial() : isLoading = false, isSuccess = false;

  SignupState copyWith({bool? isLoading, bool? isSuccess, String? role}) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess];
}
