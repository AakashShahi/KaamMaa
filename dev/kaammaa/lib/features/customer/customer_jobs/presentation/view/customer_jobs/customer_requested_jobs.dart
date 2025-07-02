import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerRequestedJobs extends StatelessWidget {
  const CustomerRequestedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CustomerRequestedJobsViewModel,
      CustomerRequestedJobsState
    >(
      builder: (context, state) {
        if (state is CustomerRequestedJobsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerRequestedJobsError) {
          return Center(child: Text(state.message));
        } else if (state is CustomerRequestedJobsLoaded) {
          final jobs = state.jobs;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CustomerRequestedJobsViewModel>().add(
                LoadCustomerRequestedJobs(),
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
                                "No requested jobs found!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Pull down to refresh.",
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
                        return GestureDetector(
                          onTap:
                              () => _showJobDetailsBottomSheet(
                                context,
                                jobs[index],
                              ),
                          child: _buildRequestedJobCard(context, jobs[index]),
                        );
                      },
                    ),
          );
        }

        return const Center(child: Text("Load requested jobs"));
      },
    );
  }

  Widget _buildRequestedJobCard(BuildContext context, CustomerJobsEntity job) {
    final hasProfilePic = job.assignedTo?.profilePic?.isNotEmpty == true;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.work_outline_rounded,
                  color: Colors.orange,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    job.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 8,
              children: [
                _infoRow(Icons.location_on, job.location),
                _infoRow(Icons.calendar_today, job.date),
                _infoRow(Icons.access_time, job.time),
                _infoRow(Icons.category, job.category.categoryName.toString()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Stack(
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
                    if (job.assignedTo?.isVerified == true)
                      const Positioned(
                        bottom: -2,
                        right: -2,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        job.assignedTo?.name?.isNotEmpty == true
                            ? job.assignedTo!.name!
                            : "Unassigned",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      if (job.assignedTo?.isVerified == true)
                        const Text(
                          "Verified",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJobDetailsBottomSheet(
    BuildContext context,
    CustomerJobsEntity job,
  ) {
    final hasProfilePic = job.assignedTo?.profilePic?.isNotEmpty == true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Job Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _detailRow(Icons.work_outline, job.description),
                _detailRow(Icons.location_on, job.location),
                _detailRow(Icons.calendar_today, job.date),
                _detailRow(Icons.access_time, job.time),
                _detailRow(
                  Icons.category,
                  job.category.categoryName.toString(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Worker Info",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              hasProfilePic
                                  ? NetworkImage(
                                    getBackendImageUrl(
                                      job.assignedTo!.profilePic!,
                                    ),
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
                        if (job.assignedTo?.isVerified == true)
                          const Positioned(
                            bottom: -2,
                            right: -2,
                            child: CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                job.assignedTo?.name ?? "Unassigned",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (job.assignedTo?.isVerified == true)
                                const Text(
                                  "Verified",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (job.assignedTo?.email != null)
                            Text(
                              "Email: ${job.assignedTo!.email}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          if (job.assignedTo?.phone != null)
                            InkWell(
                              onTap: () async {
                                final phoneNumber = job.assignedTo!.phone;
                                final Uri uri = Uri(
                                  scheme: 'tel',
                                  path: phoneNumber,
                                );

                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Cannot launch dialer"),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    job.assignedTo!.phone,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Accept Logic
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text("Accept"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Reject Logic
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text("Reject"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
