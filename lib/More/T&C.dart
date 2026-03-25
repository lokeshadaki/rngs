import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RideNGo - Terms and Conditions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildSection('1. Introduction', 'Welcome to RideNGo! These Terms and Conditions govern your use of our bike rental application and services. By accessing or using RideNGo, you agree to comply with and be bound by these Terms. If you do not agree with these Terms, please do not use our services.'),
            _buildSection('2. User Eligibility', 'To use RideNGo, you must be at least 18 years old or have the consent of a legal guardian. Provide accurate and up-to-date registration details. Agree to use the service responsibly and legally.'),
            _buildSection('3. Account Registration', 'Users must create an account to rent bikes. You are responsible for maintaining the confidentiality of your login details. Any unauthorized use of your account should be reported immediately. RideNGo reserves the right to suspend accounts that violate these Terms.'),
            _buildSection('4. Bike Rentals', 'Bikes can be rented via the RideNGo app by following the reservation process. Rental charges apply as per the pricing displayed in the app. Users must return bikes to designated docking stations or specified locations to avoid additional charges. Any loss or theft of the bike during the rental period is the users responsibility and may result in additional fees.'),
            _buildSection('5. User Responsibilities', 'Users must obey traffic laws and ride safely. Wearing a helmet is highly recommended for safety. Any damage to the bike during the rental period is the users responsibility, and repair costs may be charged.'),
            _buildSection('6. Fees and Payments', 'Payments must be made via the accepted methods in the app. Late returns may incur additional charges. RideNGo reserves the right to update pricing at any time.'),
            _buildSection('7. Cancellations and Refunds', 'Users can cancel bookings before the ride starts without incurring cancellation fees. Refund policies will be outlined in the app. No refunds will be issued for partially used rental periods or late cancellations.'),
            _buildSection('8. Liability and Indemnification', 'RideNGo is not responsible for any injuries, damages, or losses incurred while using the service. Users agree to indemnify RideNGo against any claims, liabilities, damages, or costs arising from the misuse of the service.'),
            _buildSection('9. Data Privacy', 'User data is collected, stored, and processed in accordance with our Privacy Policy. Personal information will not be shared with third parties without user consent unless required by law.'),
            _buildSection('10. Service Termination', 'RideNGo reserves the right to suspend or terminate user accounts for violations of these Terms, fraudulent activity, or misuse of the service. Users can delete their accounts at any time by contacting customer support.'),
            _buildSection('11. Changes to Terms', 'RideNGo may update these Terms periodically to reflect service changes, regulatory updates, or operational needs. Users will be notified of significant changes through the app.'),
            _buildSection('12. Contact Information', 'For any questions, concerns, or support inquiries regarding these Terms, please contact RideNGo customer support through the app or via email at support@ridengo.com.'),
            _buildSection('13. Customer Responsibility', 'Customers are responsible for ensuring the rented bike is parked in a safe, secure, and legal location. Customers must lock the bike using the provided lock (if applicable) whenever it is not in use.'),
            _buildSection('14. Bike Theft', 'In the event of bike theft while it is in the customer’s possession, the customer may be held liable for the full replacement cost of the bike, unless proven that the bike was stolen due to an error or negligence on the part of the service provider.'),
            _buildSection('15. Insurance Coverage', 'If the bike rental service offers insurance, theft may be covered provided the bike was properly locked and secured. If no insurance is selected, the customer is fully responsible for the replacement cost of the bike.'),
            _buildSection('16. Reporting the Theft', 'Customers must immediately report any theft to the local authorities and provide a copy of the police report. They should also inform our service team of the incident for further processing.'),
            _buildSection('17. Limitations of Liability', 'The company is not responsible for loss or theft of the bike once it is in the customer’s possession, unless the theft was due to a malfunction of the lock or other equipment provided.'),
            _buildSection('18. Prohibition of Bike Tampering or Disassembly', 'The customer is strictly prohibited from disassembling, modifying, or removing any parts from the rented bike. Any such action will be considered a breach of the rental agreement.'),
            _buildSection('19. Liability for Damages or Missing Parts', 'If any part of the bike is missing, damaged, or tampered with during the rental period, the customer will be held responsible for the full repair or replacement cost of the bike or its parts. The customer may be charged for the cost of the missing or damaged parts, including labor for repairs.'),
            _buildSection('20. Immediate Reporting Requirement', 'The customer must immediately report any incidents of tampering, damage, or loss of bike parts to the rental service. Failure to report such incidents promptly may lead to additional penalties or legal action.'),
            _buildSection('21. Legal Consequences', 'Selling or attempting to sell bike parts is considered theft or fraud. Any customer found engaging in such activity will be subject to legal action, including potential criminal charges and a permanent ban from the service.'),
            _buildSection('22. Security Deposit', 'A security deposit may be required at the time of rental to cover any potential damages or missing parts. This deposit will be refunded if the bike and all its parts are returned in good condition.'),
            _buildSection('23. Preventing Bike Theft and Fraud', 'To prevent the unauthorized selling of bikes or parts, we use KYC verification, GPS tracking, and admin control. If a bike is reported stolen or parts are tampered with, we can trace its location, block future rentals, and take legal action using the verified identity of the customer.'),
            _buildSection('24. KYC Verification', 'Every user must upload valid government ID (e.g., Aadhar, Driving License) to verify their identity before renting a bike.'),
            _buildSection('25. GPS Tracking', 'Each bike is tracked in real-time using GPS. Alerts will be sent if the bike moves to an unknown or restricted location (such as out of the city).'),
            _buildSection('26. Admin Monitoring', 'The admin dashboard shows all bookings, durations, and locations. If a bike isn’t returned or is flagged for unusual movement, the admin will be notified.'),
            _buildSection('27. Legal Safeguards', 'In case of fraud or theft, we maintain proof of user identity and transaction details. Legal action can be taken with the required documents, including police reports, to recover stolen property and prevent misuse of the service.'),
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