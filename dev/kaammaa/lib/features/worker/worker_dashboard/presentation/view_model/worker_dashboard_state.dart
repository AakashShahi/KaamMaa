import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WorkerDashboardState extends Equatable {
  final int selectedIndex;
  final List<Widget> widgetList;

  const WorkerDashboardState({
    this.selectedIndex = 0,
    required this.widgetList,
  });

  WorkerDashboardState copyWith({
    int? selectedIndex,
    List<Widget>? widgetList,
  }) {
    return WorkerDashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      widgetList: widgetList ?? this.widgetList,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, widgetList];
}
