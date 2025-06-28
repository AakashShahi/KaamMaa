import 'package:flutter/material.dart';

class CustomerFailedJobs extends StatelessWidget {
  const CustomerFailedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "List of Failed Jobs",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
