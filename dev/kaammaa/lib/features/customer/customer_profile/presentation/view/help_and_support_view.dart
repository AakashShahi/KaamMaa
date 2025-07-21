import 'package:flutter/material.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "If you're facing issues or need assistance, feel free to contact our support team via email at support@kaammaa.com or call us at +977-9800000000. "
          "We’re available from 9 AM to 6 PM (NST) on weekdays.",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
