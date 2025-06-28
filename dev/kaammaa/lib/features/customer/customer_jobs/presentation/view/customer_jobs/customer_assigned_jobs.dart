import 'package:flutter/material.dart';

class CustomerAssignedJobs extends StatelessWidget {
  const CustomerAssignedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "List of Assigned Jobs",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
