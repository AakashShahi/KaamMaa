import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_state.dart';
import 'package:kaammaa/features/auth/presentation/view/signup_view.dart';

class SelectionViewModel extends Cubit<SelectionState> {
  SelectionViewModel() : super(const SelectionState());

  void selectType(String type) {
    emit(state.copyWith(selectedType: type));
  }

  void onContinue(BuildContext context) {
    if (state.selectedType == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: serviceLocater<SignupViewModel>()),
                BlocProvider.value(value: serviceLocater<SelectionViewModel>()),
              ],
              child: Signupview(),
            ),
      ),
    );
  }
}
