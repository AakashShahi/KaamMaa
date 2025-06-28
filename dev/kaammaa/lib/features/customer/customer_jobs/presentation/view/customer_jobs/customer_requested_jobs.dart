import 'package:flutter/material.dart';

class CustomerRequestedJobs extends StatelessWidget {
  const CustomerRequestedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "List of Requested Jobs",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
