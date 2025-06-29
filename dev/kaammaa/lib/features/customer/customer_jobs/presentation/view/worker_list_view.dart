import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerListView extends StatefulWidget {
  final String category;
  final String jobId;

  const WorkerListView({
    super.key,
    required this.category,
    required this.jobId,
  });

  @override
  State<WorkerListView> createState() => _WorkerListViewState();
}

class _WorkerListViewState extends State<WorkerListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CustomerWorkerListViewModel>().add(
        LoadWorkersByCategory(widget.category),
      );
    });
  }

  void _launchDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber.trim());
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cannot launch dialer")));
    }
  }

  Future<void> showAssignWorkerDialog({
    required BuildContext context,
    required String workerName,
    required String jobId,
    required String workerId,
  }) async {
    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.all(20),
            title: Column(
              children: [
                Image.asset('assets/logo/kaammaa.png', height: 80),
                const SizedBox(height: 12),
                Text(
                  'Confirm Assignment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to assign $workerName to this job?',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text("Confirm"),
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close the dialog

                  context.read<CustomerWorkerListViewModel>().add(
                    AssignWorkerToJob(
                      jobId: jobId,
                      workerId: workerId,
                      context: context,
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Select Worker"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocBuilder<CustomerWorkerListViewModel, CustomerWorkerListState>(
        builder: (context, state) {
          if (state is CustomerWorkerListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerWorkerListError) {
            return Center(child: Text(state.message));
          } else if (state is CustomerWorkerListLoaded) {
            final workers = state.workers;

            if (workers.isEmpty) {
              return const Center(child: Text("No workers found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                final imageUrl =
                    worker.profilePic != null
                        ? getBackendImageUrl(worker.profilePic!)
                        : null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                height: 56,
                                width: 56,
                                child:
                                    imageUrl != null
                                        ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        )
                                        : Container(
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 18),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          worker.name ?? "No Name",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        worker.location ?? "No Location",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.work, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        worker.profession.categoryName ??
                                            "No Profession",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        worker.phone,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        worker.isVerified
                                            ? Icons.verified
                                            : Icons.verified_outlined,
                                        color:
                                            worker.isVerified
                                                ? Colors.green
                                                : Colors.grey,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        worker.isVerified
                                            ? "Verified"
                                            : "Not Verified",
                                        style: TextStyle(
                                          color:
                                              worker.isVerified
                                                  ? Colors.green
                                                  : Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    children:
                                        worker.skills
                                            .map(
                                              (skill) => Chip(
                                                label: Text(
                                                  skill,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.call, size: 18),
                              label: Text('Call ${worker.name ?? "Worker"}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _launchDialer(worker.phone),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                showAssignWorkerDialog(
                                  context: context,
                                  workerName: worker.name ?? "Worker",
                                  jobId: widget.jobId,
                                  workerId: worker.id.toString(),
                                );
                              },
                              child: const Text("Select"),
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
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
