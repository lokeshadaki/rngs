import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rngs/Admin/UserBookingDetails.dart';
import 'package:rngs/Admin/UserKYC.dart';
import 'package:rngs/Admin/UserProfile.dart';

class AdminBookingPage extends StatefulWidget {
  const AdminBookingPage({Key? key}) : super(key: key);

  @override
  _AdminBookingPageState createState() => _AdminBookingPageState();
}

class _AdminBookingPageState extends State<AdminBookingPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Admin Booking Dashboard"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Username or Bike',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No bookings found."));
                }

                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final username = (data['username'] ?? '').toString().toLowerCase();
                  final bikeName = (data['name'] ?? '').toString().toLowerCase();
                  return username.contains(searchQuery) || bikeName.contains(searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("No matching bookings found."));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final booking = doc.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Username: ${booking['username'] ?? 'N/A'}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text("Bike: ${booking['name'] ?? 'N/A'}", style: const TextStyle(fontSize: 15, color: Colors.black87)),
                            const SizedBox(height: 10),
                            const Divider(),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildActionButton(
                                  label: "Start OTP",
                                  icon: Icons.lock_open,
                                  color: Colors.green,
                                  onPressed: () async {
                                    await _verifyOtp(context, "Verify Start OTP",
                                      booking['startotp'].toString(),
                                          () async {
                                        await FirebaseFirestore.instance.collection('bookings').doc(doc.id).update({'isStarted': true});
                                        _showMessage("Start OTP verified. Ride started.");
                                      },
                                    );
                                  },
                                ),
                                _buildActionButton(
                                  label: "End OTP",
                                  icon: Icons.lock,
                                  color: Colors.red,
                                  onPressed: () async {
                                    await _verifyOtp(context, "Verify End OTP",
                                      booking['endotp'].toString(),
                                          () async {
                                        try {
                                          await FirebaseFirestore.instance.collection('history').doc(doc.id).set(booking);
                                          await FirebaseFirestore.instance.collection('bookings').doc(doc.id).delete();
                                          _showMessage("End OTP verified. Booking moved to history.");
                                        } catch (e) {
                                          _showMessage("Error during Firestore operation: $e");
                                        }
                                      },
                                    );
                                  },
                                ),

                                _buildActionButton(
                                  label: "User Profile",
                                  icon: Icons.person,
                                  color: Colors.blueGrey,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AdminUserProfile(userId: booking['userId']),
                                      ),
                                    );
                                  },
                                ),
                                _buildActionButton(
                                  label: "User KYC",
                                  icon: Icons.verified_user,
                                  color: Colors.orangeAccent,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AdminUserKYC(userId: booking['userId']),
                                      ),
                                    );
                                  },
                                ),
                                _buildActionButton(
                                  label: "Booking Details",
                                  icon: Icons.receipt_long,
                                  color: Colors.deepPurple,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AdminBookingDetails(data: booking),
                                      ),
                                    );
                                  },
                                ),
                                _buildActionButton(
                                  label: "Reject Booking",
                                  icon: Icons.cancel,
                                  color: Colors.redAccent,
                                  onPressed: () async {
                                    String generatedOtp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

                                    try {
                                      await FirebaseFirestore.instance.collection('cancelled').doc(doc.id).set({
                                        ...booking,
                                        'cancelledAt': DateTime.now().toIso8601String(),
                                        'rejectedOtp': generatedOtp,
                                        'status': 'rejected_by_admin',
                                      });

                                      await FirebaseFirestore.instance.collection('bookings').doc(doc.id).delete();

                                      _showMessage("Booking rejected. OTP: $generatedOtp");
                                    } catch (e) {
                                      _showMessage("Error rejecting booking: $e");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyOtp(
      BuildContext context,
      String title,
      String correctOtp,
      Function onSuccess,
      ) async {
    String enteredOtp = "";

    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            maxLength: 6,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter 6-digit OTP"),
            onChanged: (value) => enteredOtp = value,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Verify")),
          ],
        );
      },
    );

    if (result == true) {
      if (enteredOtp == correctOtp) {
        try {
          await onSuccess();
          _showMessage("OTP verified and operation successful.");
        } catch (e) {
          print("Error during Firestore operation: $e");
          _showMessage("An error occurred while processing the OTP.");
        }
      } else {
        _showMessage("Incorrect OTP");
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
