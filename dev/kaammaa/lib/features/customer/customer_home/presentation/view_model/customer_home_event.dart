import 'package:equatable/equatable.dart';

abstract class CustomerHomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCustomerHomeData extends CustomerHomeEvent {}
