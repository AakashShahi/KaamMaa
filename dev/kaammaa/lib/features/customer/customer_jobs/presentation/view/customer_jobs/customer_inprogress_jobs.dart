import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInprogressJobs extends StatelessWidget {
  const CustomerInprogressJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CustomerInProgressJobsViewModel,
      CustomerInProgressJobsState
    >(
      builder: (context, state) {
        if (state is CustomerInProgressJobsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerInProgressJobsError) {
          return Center(child: Text(state.message));
        } else if (state is CustomerInProgressJobsLoaded) {
          final jobs = state.jobs;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CustomerInProgressJobsViewModel>().add(
                LoadCustomerInProgressJobs(),
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
                                "No in-progress jobs found!",
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
                          child: _buildJobCard(context, jobs[index]),
                        );
                      },
                    ),
          );
        }

        return const Center(child: Text("Load in-progress jobs"));
      },
    );
  }

  Widget _buildJobCard(BuildContext context, CustomerJobsEntity job) {
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
                job.icon != null
                    ? Image.network(
                      getBackendImageUrl(job.icon!),
                      height: 24,
                      width: 24,
                    )
                    : const Icon(Icons.work, color: Colors.orange, size: 26),
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
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    job.assignedTo?.name ?? "Unassigned",
                    style: const TextStyle(fontWeight: FontWeight.w600),
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
                  "In-Progress Job Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _detailRow(Icons.description, job.description),
                _detailRow(Icons.location_on, job.location),
                _detailRow(Icons.calendar_today, job.date),
                _detailRow(Icons.access_time, job.time),
                _detailRow(
                  Icons.category,
                  job.category.categoryName.toString(),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          hasProfilePic
                              ? NetworkImage(
                                getBackendImageUrl(job.assignedTo!.profilePic!),
                              )
                              : null,
                      child:
                          !hasProfilePic
                              ? Image.asset("assets/logo/kaammaa.png")
                              : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.assignedTo?.name ?? "Unassigned",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
                  ],
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chat",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 250,
                  child: ListView(
                    children: [
                      _buildChatBubble("Hi, I’m on the way.", isWorker: true),
                      _buildChatBubble("Okay, thank you!", isWorker: false),
                      _buildChatBubble(
                        "Please bring your tools.",
                        isWorker: false,
                      ),
                      _buildChatBubble("Sure, all set.", isWorker: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    prefixIcon: const Icon(Icons.message),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        // TODO: Integrate send message logic
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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

  Widget _buildChatBubble(String text, {required bool isWorker}) {
    final alignment =
        isWorker ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isWorker ? Colors.orange.shade200 : Colors.grey.shade200;
    final radius =
        isWorker
            ? const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            )
            : const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          constraints: const BoxConstraints(maxWidth: 260),
          decoration: BoxDecoration(color: color, borderRadius: radius),
          child: Text(text, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
