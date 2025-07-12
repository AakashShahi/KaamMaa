import 'package:equatable/equatable.dart';

class SelectionState extends Equatable {
  final String? selectedType;

  const SelectionState({this.selectedType});

  SelectionState copyWith({String? selectedType}) {
    return SelectionState(selectedType: selectedType ?? this.selectedType);
  }

  @override
  List<Object?> get props => [selectedType];
}
