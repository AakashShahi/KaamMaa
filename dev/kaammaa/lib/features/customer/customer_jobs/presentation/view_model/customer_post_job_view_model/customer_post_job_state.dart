// customer_post_jobs_state.dart
import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';

abstract class CustomerPostJobsState extends Equatable {
  const CustomerPostJobsState();

  @override
  List<Object?> get props => [];
}

class CustomerPostJobsInitial extends CustomerPostJobsState {}

class CategoriesLoading extends CustomerPostJobsState {}

class CategoriesLoaded extends CustomerPostJobsState {
  final List<CustomerCategoryEntity> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesLoadFailure extends CustomerPostJobsState {
  final String message;

  const CategoriesLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CustomerPostJobsLoading extends CustomerPostJobsState {}

class CustomerPostJobsSuccess extends CustomerPostJobsState {}

class CustomerPostJobsFailure extends CustomerPostJobsState {
  final String message;

  const CustomerPostJobsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
