import 'package:flutter/material.dart';
import 'package:kaammaa/core/common/app_colors.dart';

class CustomerNotificationView extends StatefulWidget {
  const CustomerNotificationView({super.key});

  @override
  State<CustomerNotificationView> createState() =>
      _CustomerNotificationViewState();
}

class _CustomerNotificationViewState extends State<CustomerNotificationView> {
  List<String> notifications = [
    "Ram Thapa requested a job.",
    "Worker accepted your job request.",
  ];

  void _clearAll() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _clearAll,
              tooltip: 'Delete All',
            ),
        ],
      ),
      body:
          notifications.isEmpty
              ? const Center(
                child: Text(
                  "No notifications",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications_active,
                        color: Colors.orange,
                      ),
                      title: Text(notifications[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            notifications.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
