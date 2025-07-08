import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_assigned_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_failed_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_inprogress_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_posted_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_requested_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_view_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_viewmodel.dart';

class CustomerJobsView extends StatelessWidget {
  const CustomerJobsView({super.key});

  List<Tab> get _tabs => const [
    Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("Posted"),
      ),
    ),
    Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("Assigned"),
      ),
    ),
    Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("In Progress"),
      ),
    ),
    Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("Requested"),
      ),
    ),
    Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("Failed"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2, // "In Progress" tab default
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primary.withOpacity(0.08),
            child: TabBar(
              isScrollable: true,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: _tabs,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              children: [
                BlocProvider<CustomerPostedJobsViewModel>(
                  create:
                      (_) =>
                          serviceLocater<CustomerPostedJobsViewModel>()..add(
                            LoadCustomerPostedJobs(),
                          ), // Add your load event here
                  child: const CustomerPostedJobs(),
                ),
                BlocProvider<CustomerAssignedJobsViewModel>(
                  create:
                      (_) =>
                          serviceLocater<CustomerAssignedJobsViewModel>()
                            ..add(LoadCustomerAssignedJobs()), // Load event
                  child: const CustomerAssignedJobs(),
                ),
                BlocProvider<CustomerInProgressJobsViewModel>(
                  create:
                      (_) =>
                          serviceLocater<CustomerInProgressJobsViewModel>()
                            ..add(LoadCustomerInProgressJobs()),
                  child: const CustomerInprogressJobs(),
                ),
                BlocProvider<CustomerRequestedJobsViewModel>(
                  create:
                      (_) =>
                          serviceLocater<CustomerRequestedJobsViewModel>()
                            ..add(LoadCustomerRequestedJobs()),
                  child: const CustomerRequestedJobs(),
                ),
                CustomerFailedJobs(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
