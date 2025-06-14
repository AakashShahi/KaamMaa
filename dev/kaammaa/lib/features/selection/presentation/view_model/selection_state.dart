class SelectionState {
  final String? selectedType;

  const SelectionState({this.selectedType});

  SelectionState copyWith({String? selectedType}) {
    return SelectionState(selectedType: selectedType ?? this.selectedType);
  }
}
