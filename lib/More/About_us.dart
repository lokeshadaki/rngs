import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ABOUT US', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 20),
              _buildSection(
                'OUR VISION',
                'To democratize micro-mobility as a service by removing all roadblocks between people and mobility.\n\n'
                    '"We thrive to make mobility so ingrained in your lifestyle that it becomes a fundamental right."',
              ),
              SizedBox(height: 20),
              _buildSection(
                'OUR MISSION',
                'To constantly evolve and provide micro-mobility solutions by solving the problem of daily transportation.\n\n'
                    '"Helping commuters and travelers get to exactly where they need to go through innovative solutions."',
              ),
              SizedBox(height: 20),
              _buildThreePillarsSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset('assets/img/photo2.jpg', fit: BoxFit.cover),
              ),
              Positioned(
                top: 10,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RideNGo RENTALS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MEET RIDENGO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'RideNGo was founded on a simple idea of FREEDOM in mobility.\n\n'
                      'We felt that like everything in today’s world, mobility also needed an update. '
                      'Thus began our quest to create a Smart, Affordable, and accessible mobility option. '
                      'Freedo provides safe, happy, and reliable commute services to our customers through '
                      'exclusive self-driving two-wheelers.\n\n'
                      'Freedo for a sustainable tomorrow aims to reduce dependence on personal vehicle ownership '
                      'by introducing user-ship through shared vehicles, leaving the planet a bit healthier. '
                      'Choose Freedom to Move, Choose Freedo!',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreePillarsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage('assets/img/photo1.jpg'), // Background Image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.6), // Dark overlay for readability
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'OUR THREE PILLARS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPillarItem('Empathy', 'assets/img/p1.jpg'),
                  _buildPillarItem('Innovation', 'assets/img/p2.jpg'),
                  _buildPillarItem('Team Work', 'assets/img/p3.jpg'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarItem(String title, String iconPath) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withOpacity(0.8),
          ),
          child: Center(
            child: Image.asset(iconPath, width: 30, height: 30),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
