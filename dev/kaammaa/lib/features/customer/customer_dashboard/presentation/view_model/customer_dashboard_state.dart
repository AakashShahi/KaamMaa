import 'package:flutter/material.dart';

class CustomerDashboardState {
  final int selectedIndex;
  final List<Widget> widgetList;

  CustomerDashboardState({
    required this.selectedIndex,
    required this.widgetList,
  });

  CustomerDashboardState copyWith({
    int? selectedIndex,
    List<Widget>? widgetList,
  }) {
    return CustomerDashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      widgetList: widgetList ?? this.widgetList,
    );
  }
}
