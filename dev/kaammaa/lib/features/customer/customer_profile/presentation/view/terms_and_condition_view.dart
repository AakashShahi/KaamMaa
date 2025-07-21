import 'package:flutter/material.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms and Conditions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Terms and Conditions

Welcome to Kaammaa!

These terms and conditions outline the rules and regulations for the use of the Kaammaa app. By accessing or using our platform, you agree to be bound by these terms.

1. **User Responsibilities**: 
   Users must provide accurate information, respect other users, and comply with all applicable laws.

2. **Privacy Policy**:
   All personal data is handled in accordance with our privacy policy. We do not share or sell your information.

3. **Dispute Resolution**:
   In case of disputes, our team will mediate fairly. Continued misconduct can lead to account suspension.

5. **Modification of Terms**:
   We reserve the right to update or change these terms at any time. Changes will be notified via app or email.

Thank you for using Kaammaa – connecting you with trusted workers and local opportunities.''',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
