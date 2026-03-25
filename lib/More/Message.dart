import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: user == null
          ? const Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, bookingSnapshot) {
          if (bookingSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!bookingSnapshot.hasData || bookingSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bookings found."));
          }

          final bookings = bookingSnapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final bookingDoc = bookings[index];
              final bookingData = bookingDoc.data() as Map<String, dynamic>? ?? {};

              // booking data
              final bikeName = bookingData['name'] ?? 'Unknown';
              final price = bookingData['price']?.toString() ?? '0';
              final total = bookingData['totalAmount']?.toString() ?? '0';

              final startotp = bookingData['startotp'] is int ? bookingData['startotp'] : int.tryParse(bookingData['startotp']?.toString() ?? '0') ?? 0;
              final endotp = bookingData['endotp'] is int ? bookingData['endotp'] : int.tryParse(bookingData['endotp']?.toString() ?? '0') ?? 0;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bike: $bikeName", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Price: ₹$price", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      Text("Total Amount: ₹$total", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(height: 10),
                      Text("Rental OTP: $startotp", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("End OTP: $endotp", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Message: Your OTP is $startotp. Please verify to start the rental period.", style: TextStyle(fontSize: 16)),
                      Text("Message: Your OTP is $endotp. Please verify to end the rental period.", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
