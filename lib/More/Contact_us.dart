import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CONTACT US"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reach out to us in various ways!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              ContactSection(
                title: "Corporate Address",
                details: "13/14 Gandhi Nagar Akkalkot Road, Solapur, India",
              ),
              SizedBox(height: 20),
              ContactSection(
                  title: "Regional Office Address",
                  details:"Under Developing"
              ),
              SizedBox(height: 20),
              ContactSection(
                title: "Email",
                details: "contact@ridengo.com",
                icon: Icons.email,
              ),
              SizedBox(height: 20),
              ContactSection(
                title: "Mobile",
                details: "+91 95998 19940",
                icon: Icons.phone,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  final String title;
  final String details;
  final IconData? icon;

  ContactSection({required this.title, required this.details, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(icon, color: Colors.teal, size: 24),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 5),
              Text(details, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
