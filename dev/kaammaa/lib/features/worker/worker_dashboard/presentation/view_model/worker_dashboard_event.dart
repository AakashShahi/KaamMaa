import 'package:equatable/equatable.dart';

abstract class WorkerDashboardEvent extends Equatable {
  const WorkerDashboardEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTabEvent extends WorkerDashboardEvent {
  final int newIndex;

  const ChangeTabEvent({required this.newIndex});

  @override
  List<Object?> get props => [newIndex];
}
