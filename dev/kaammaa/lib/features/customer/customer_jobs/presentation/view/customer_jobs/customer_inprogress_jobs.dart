import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/constant/chat/chat_service.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view/submit_review_view.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_reviews_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                CustomerInprogressJobs._infoRow(
                  Icons.location_on,
                  job.location,
                ),
                CustomerInprogressJobs._infoRow(Icons.calendar_today, job.date),
                CustomerInprogressJobs._infoRow(Icons.access_time, job.time),
                CustomerInprogressJobs._infoRow(
                  Icons.category,
                  job.category.categoryName.toString(),
                ),
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider<SubmitReviewViewModel>(
                          create:
                              (_) => serviceLocater<SubmitReviewViewModel>(),
                          child: SubmitReviewView(jobId: job.jobId!),
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "Mark as complete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Making _infoRow a static helper since it doesn't depend on instance state
  static Widget _infoRow(IconData icon, String text) {
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

  void _showJobDetailsBottomSheet(
    BuildContext context,
    CustomerJobsEntity job,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final TokenSharedPrefs tokenSharedPrefs = TokenSharedPrefs(
      sharedPreferences: prefs,
    );

    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => debugPrint("Failed to get token: ${failure.message}"),
      (t) => token = t,
    );

    final userIdResult = await tokenSharedPrefs.getUserId();
    String? currentCustomerUserId;
    userIdResult.fold(
      (failure) =>
          debugPrint("Failed to get current user ID: ${failure.message}"),
      (id) => currentCustomerUserId = id,
    );

    if (token == null ||
        token!.isEmpty ||
        currentCustomerUserId == null ||
        currentCustomerUserId!.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Authentication token or user ID not found. Cannot open chat.",
            ),
          ),
        );
      }
      return;
    }

    final ChatService chatService = ChatService(
      token: token!,
      jobId: job.jobId!,
      currentUserId: currentCustomerUserId!,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return _ChatBottomSheetContent(
          job: job,
          currentCustomerUserId: currentCustomerUserId!,
          chatService: chatService,
        );
      },
    );
  }
}

// --- STATEFUL WIDGET FOR BOTTOM SHEET CONTENT ---
class _ChatBottomSheetContent extends StatefulWidget {
  final CustomerJobsEntity job;
  final String currentCustomerUserId;
  final ChatService chatService;

  const _ChatBottomSheetContent({
    required this.job,
    required this.currentCustomerUserId,
    required this.chatService,
  });

  @override
  State<_ChatBottomSheetContent> createState() =>
      _ChatBottomSheetContentState();
}

class _ChatBottomSheetContentState extends State<_ChatBottomSheetContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // We don't need a local _chatMessages list anymore.
  // ValueListenableBuilder will directly listen to widget.chatService.messagesNotifier.

  @override
  void initState() {
    super.initState();
    // Connect and fetch history using the passed chatService
    widget.chatService.connect();
    widget.chatService.fetchChatHistory();

    // Listen to messagesNotifier directly
    // This listener will call setState to trigger a rebuild of the _ChatBottomSheetContentState
    // which in turn will cause the ValueListenableBuilder to rebuild with the new value.
    widget.chatService.messagesNotifier.addListener(_onMessagesUpdated);

    // Initial scroll in case history is already loaded before listener attached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    // Remove listener and dispose chatService when this stateful widget is disposed
    widget.chatService.messagesNotifier.removeListener(_onMessagesUpdated);
    widget.chatService.dispose(); // Dispose the ChatService here
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Callback for messagesNotifier updates
  void _onMessagesUpdated() {
    // Calling setState here rebuilds _ChatBottomSheetContentState,
    // which then causes the ValueListenableBuilder inside its build method to re-evaluate
    // its valueListenable, and thus rebuild its builder function with the latest messages.
    setState(() {
      // No need to update _chatMessages here, as ValueListenableBuilder directly observes messagesNotifier.value
    });
    _scrollToBottom(); // Scroll after state update
  }

  void _scrollToBottom() {
    // Ensure we are in a safe frame to scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Helper method for detail rows (moved here)
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

  // Helper method for chat bubbles (moved here)
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

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final String? assignedWorkerId = job.assignedTo?.id;
    final String currentCustomerUserId = widget.currentCustomerUserId;

    final bool hasProfilePic = job.assignedTo?.profilePic?.isNotEmpty == true;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        MediaQuery.of(context).viewInsets.bottom + 30,
      ),
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
          _detailRow(Icons.category, job.category.categoryName.toString()),
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
                        final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

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
                          const Icon(Icons.phone, color: Colors.blue, size: 20),
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
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: widget.chatService.messagesNotifier,
              builder: (context, messages, child) {
                // messages parameter here automatically receives the updated list from ValueNotifier
                if (messages.isEmpty) {
                  return const Center(
                    child: Text("No messages yet. Start chatting!"),
                  );
                }

                return ListView.builder(
                  key: ValueKey(
                    messages.length,
                  ), // FIX: Add a key that changes with message count
                  controller: _scrollController,
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, msgIndex) {
                    final message = messages[msgIndex];
                    final String? actualSenderId =
                        message["senderId"] is Map
                            ? (message["senderId"] as Map)["_id"] as String?
                            : message["senderId"] as String?;

                    final bool isAssignedWorkerMessage =
                        actualSenderId == assignedWorkerId;
                    final bool isCurrentUserMessage =
                        actualSenderId == currentCustomerUserId;

                    final bool shouldAlignRight =
                        isAssignedWorkerMessage && !isCurrentUserMessage;

                    return _buildChatBubble(
                      message["content"],
                      isWorker: shouldAlignRight,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: "Type your message...",
              prefixIcon: const Icon(Icons.message),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    widget.chatService.sendMessage(_messageController.text);
                    _messageController.clear();
                  }
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
    );
  }
}
