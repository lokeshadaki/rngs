import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUserProfile extends StatelessWidget {
  final String userId;

  const AdminUserProfile({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User profile not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileImage(context, data),
                    const SizedBox(height: 20),
                    Text(
                      "${data['firstName']} ${data['lastName']}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['email'],
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    _buildProfileRow("Mobile", data['mobile']),
                    _buildProfileRow("Gender", data['gender']),
                    _buildProfileRow("Emergency Contact", data['emergencyContact']),
                    _buildProfileRow("Relation", data['relation']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, Map<String, dynamic> data) {
    String? profileImage = data['profileImage'];

    return GestureDetector(
      onTap: () {
        if (profileImage != null && profileImage.isNotEmpty) {
          // Show full-screen image with zoom control
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: EdgeInsets.all(20),
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(profileImage),
              ),
            ),
          );
        }
      },
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.deepPurple[100],
        backgroundImage: profileImage != null && profileImage.isNotEmpty
            ? NetworkImage(profileImage)
            : null,
        child: profileImage == null || profileImage.isEmpty
            ? const Icon(Icons.person, size: 50, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildProfileRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
