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
    Tab(text: "Posted"),
    Tab(text: "Assigned"),
    Tab(text: "In Progress"),
    Tab(text: "Requested"),
    Tab(text: "Failed"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primary.withOpacity(0.1),
            child: TabBar(
              isScrollable: true,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: _tabs,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                const CustomerPostedJobs(),
                const CustomerAssignedJobs(),
                const CustomerInprogressJobs(),
                const CustomerRequestedJobs(),
                const CustomerFailedJobs(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
