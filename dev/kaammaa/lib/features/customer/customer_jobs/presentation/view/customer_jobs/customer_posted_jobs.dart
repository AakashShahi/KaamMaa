import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_alertdialog.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/worker_list_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_viewmodel.dart';

class CustomerPostedJobs extends StatelessWidget {
  const CustomerPostedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerPostedJobsViewModel, CustomerPostedJobsState>(
      builder: (context, state) {
        if (state is CustomerPostedJobsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerPostedJobsError) {
          return Center(child: Text(state.message));
        } else if (state is CustomerPostedJobsLoaded) {
          final jobs = state.jobs;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CustomerPostedJobsViewModel>().add(
                LoadCustomerPostedJobs(),
              );
            },
            child:
                jobs.isEmpty
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/logo/kaammaa.png',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "No posted jobs found!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Pull down to refresh or post a new job.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return _buildJobCard(context, job);
                      },
                    ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child:
                  job.category.categoryImage != null
                      ? Image.network(
                        getBackendImageUrl(job.category.categoryImage!),
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Icon(
                              Icons.work,
                              size: 32,
                              color: Colors.orange,
                            ),
                      )
                      : const Icon(Icons.work, size: 32, color: Colors.orange),
            ),
            const SizedBox(width: 12),

            // Job Info & Actions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _infoRow(Icons.location_on, job.location),
                      _infoRow(
                        Icons.category,
                        job.category.category.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 16,
                    children: [
                      _infoRow(Icons.calendar_today, job.date),
                      _infoRow(Icons.access_time, job.time),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value:
                                          serviceLocater<
                                            CustomerWorkerListViewModel
                                          >(),
                                      child: WorkerListView(
                                        category:
                                            job.category.categoryName
                                                .toString(),
                                        jobId: job.jobId.toString(),
                                      ),
                                    ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                context.read<CustomerPostedJobsViewModel>().add(
                                  LoadCustomerPostedJobs(),
                                );
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.assignment_turned_in,
                            color: Colors.green,
                            size: 20,
                          ),
                          label: const Text(
                            "Assign",
                            style: TextStyle(color: Colors.green),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AppAlertDialog(
                                    title: "Delete Job",
                                    message:
                                        "Are you sure you want to delete this job?",
                                    confirmText: "Delete",
                                    cancelText: "Cancel",
                                    onConfirmed: () {
                                      Navigator.pop(context);
                                      context
                                          .read<CustomerPostedJobsViewModel>()
                                          .add(
                                            DeleteCustomerPostedJob(
                                              jobId: job.jobId.toString(),
                                              context: context,
                                            ),
                                          );
                                    },
                                  ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          label: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
