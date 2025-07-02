import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_view_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';

class CustomerAssignedJobs extends StatelessWidget {
  const CustomerAssignedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CustomerAssignedJobsViewModel,
      CustomerAssignedJobsState
    >(
      builder: (context, state) {
        if (state is CustomerAssignedJobsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerAssignedJobsError) {
          return Center(child: Text(state.message));
        } else if (state is CustomerAssignedJobsLoaded) {
          final jobs = state.jobs;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CustomerAssignedJobsViewModel>().add(
                LoadCustomerAssignedJobs(),
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
                                "No assigned jobs found!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Pull down to refresh or wait for assignment.",
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
                        return _buildAssignedJobCard(jobs[index]);
                      },
                    ),
          );
        }

        return const Center(child: Text("Press button to load jobs"));
      },
    );
  }

  Widget _buildAssignedJobCard(CustomerJobsEntity job) {
    final hasProfilePic =
        job.assignedTo?.profilePic != null &&
        job.assignedTo!.profilePic!.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.description,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 16,
              children: [
                _infoRow(Icons.location_on, job.location),
                _infoRow(Icons.calendar_today, job.date),
                _infoRow(Icons.access_time, job.time),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      hasProfilePic
                          ? NetworkImage(
                            getBackendImageUrl(job.assignedTo!.profilePic!),
                          )
                          : null,
                  child:
                      !hasProfilePic
                          ? Image.asset(
                            "assets/logo/kaammaa.png",
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    job.assignedTo!.name?.isNotEmpty == true
                        ? job.assignedTo!.name!
                        : "Unknown Worker",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: implement cancel logic
                    print("Cancel ${job.jobId}");
                  },
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
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
