import 'package:flutter/material.dart';

class CustomerDashboardState {
  final int selectedIndex;
  final List<Widget> widgetList;
  final String? userName;
  final String? userPhoto;

  CustomerDashboardState({
    required this.selectedIndex,
    required this.widgetList,
    this.userName,
    this.userPhoto,
  });

  CustomerDashboardState copyWith({
    int? selectedIndex,
    List<Widget>? widgetList,
    String? userName,
    String? userPhoto,
  }) {
    return CustomerDashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      widgetList: widgetList ?? this.widgetList,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
    );
  }
}
