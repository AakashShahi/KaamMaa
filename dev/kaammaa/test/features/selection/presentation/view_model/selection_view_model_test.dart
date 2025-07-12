import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_state.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';

void main() {
  group('SelectionViewModel', () {
    late SelectionViewModel selectionViewModel;

    setUp(() {
      selectionViewModel = SelectionViewModel();
    });

    blocTest<SelectionViewModel, SelectionState>(
      'emits updated state when selectType is called',
      build: () => selectionViewModel,
      act: (cubit) => cubit.selectType('worker'),
      expect: () => [const SelectionState(selectedType: 'worker')],
    );
  });
}
