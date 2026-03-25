import 'package:flutter/material.dart';
import 'package:rngs/Admin/AdminBooking.dart';
import 'package:rngs/Admin/AdminHistory.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMenuCard(
              context,
              icon: Icons.directions_bike,
              title: "Booking Bike",
              subtitle: "View and verify current bookings",
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminBookingPage()))
              }
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context,
              icon: Icons.history,
              title: "History",
              subtitle: "See all past bookings",
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminHistoryPage()))
              },
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context,
              icon: Icons.logout,
              title: "Logout",
              subtitle: "Sign out of admin dashboard",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Icon(icon, color: Colors.deepPurple),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
