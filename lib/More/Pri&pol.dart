import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RideNGo - Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildSection('1. Introduction', 'Welcome to RideNGo! Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal data when you use our services.'),
            _buildSection('2. Information We Collect', '- Personal Information: Name, email, phone number, ID verification data.\n- Payment Information: Transactions are securely processed, and full details are not stored.\n- Location Data: Used for navigation and ride tracking.\n- Ride Data: Start and end locations, distance, and duration are recorded.\n- Device Information: Includes model, OS version, and app usage analytics.'),
            _buildSection('3. How We Use Your Information', '- Service Provision: Account management, ride tracking, and payment processing.\n- Security: Fraud detection and identity verification.\n- Improvements: Enhancing app functionality and user experience.'),
            _buildSection('4. Data Sharing & Third-Party Disclosure', '- We do not sell user data.\n- Shared only with payment processors, cloud storage, and law enforcement if required.'),
            _buildSection('5. User Rights & Control', '- Users can update, access, or request data deletion via app settings.\n- Marketing preferences can be managed within the app.'),
            _buildSection('6. Security Measures', 'Encryption and access control protect user data. No system is 100% secure, and users should enable strong passwords.'),
            _buildSection('7. Data Retention', '- Ride history and transactions are stored for up to 5 years.\n- Account information is kept until users request deletion.'),
            _buildSection('8. Cookies & Tracking', '- Used for app performance and analytics.\n- Users can manage cookie preferences in settings.'),
            _buildSection('9. Children’s Privacy', 'RideNGo is not intended for children under 13. If personal data is collected from minors, it will be deleted immediately.'),
            _buildSection('10. Changes to Privacy Policy', 'We may update this policy periodically. Users will be notified of major changes.'),
            _buildSection('11. Contact Information', 'For privacy concerns, contact us at privacy@ridengo.com.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}