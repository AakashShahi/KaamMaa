import 'package:flutter/material.dart';

@immutable
abstract class CustomerInProgressJobsEvent {}

class LoadCustomerInProgressJobs extends CustomerInProgressJobsEvent {}
