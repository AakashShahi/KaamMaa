import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';

abstract class CustomerPostJobsEvent extends Equatable {
  const CustomerPostJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CustomerPostJobsEvent {}

class PostJobRequested extends CustomerPostJobsEvent {
  final String description;
  final String location;
  final CustomerCategoryEntity category;
  final String date;
  final String time;
  final BuildContext context;

  const PostJobRequested({
    required this.description,
    required this.location,
    required this.category,
    required this.date,
    required this.time,
    required this.context,
  });

  @override
  List<Object?> get props => [description, location, category, date, time];
}
