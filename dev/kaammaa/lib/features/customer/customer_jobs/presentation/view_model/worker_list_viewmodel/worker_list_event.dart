import 'package:equatable/equatable.dart';

abstract class CustomerWorkerListEvent extends Equatable {
  const CustomerWorkerListEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkersByCategory extends CustomerWorkerListEvent {
  final String category;

  const LoadWorkersByCategory(this.category);

  @override
  List<Object?> get props => [category];
}
