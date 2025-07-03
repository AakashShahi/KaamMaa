import 'package:flutter/material.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_assigned_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_failed_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_inprogress_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_posted_jobs.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs/customer_requested_jobs.dart';

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
          const Expanded(
            child: TabBarView(
              children: [
                CustomerPostedJobs(),
                CustomerAssignedJobs(),
                CustomerInprogressJobs(),
                CustomerRequestedJobs(),
                CustomerFailedJobs(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
