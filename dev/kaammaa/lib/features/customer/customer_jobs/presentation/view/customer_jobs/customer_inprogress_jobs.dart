import 'package:flutter/material.dart';

class CustomerInprogressJobs extends StatelessWidget {
  const CustomerInprogressJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "List of In Progress Job",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
