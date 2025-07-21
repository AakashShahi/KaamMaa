import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/auth/domain/use_case/get_current_user_usecase.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_event.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_state.dart';

class CustomerProfileViewModel
    extends Bloc<CustomerProfileEvent, CustomerProfileState> {
  final GetCurrentUserUsecase _getCurrentUserUsecase;

  CustomerProfileViewModel(this._getCurrentUserUsecase)
    : super(CustomerProfileInitial()) {
    on<FetchCustomerProfileEvent>((event, emit) async {
      emit(CustomerProfileLoading());
      final result = await _getCurrentUserUsecase();
      result.fold(
        (failure) => emit(CustomerProfileError(failure)),
        (user) => emit(CustomerProfileLoaded(user)),
      );
    });
  }
}
