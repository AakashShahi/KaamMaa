import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_state.dart';
import 'package:kaammaa/view/signup_view.dart';

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
            (context) => const Signupview(), // Or pass selectedType if needed
      ),
    );
  }
}
