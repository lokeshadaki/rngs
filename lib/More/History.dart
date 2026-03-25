import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rngs/BookingDetails.dart';
import 'package:rngs/More/HistoryFullDetails.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatDate(dynamic value) {
    if (value == null) return '-';
    if (value is Timestamp) {
      DateTime date = value.toDate();
      return "${date.day}/${date.month}/${date.year}";
    } else {
      return value.toString();
    }
  }

  String formatTime(dynamic value) {
    if (value == null) return '-';
    if (value is Timestamp) {
      DateTime date = value.toDate();
      return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: user == null
          ? const Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('history')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bikes History yet!"));
          }

          final bookedBikes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookedBikes.length,
            itemBuilder: (context, index) {
              final bikeDoc = bookedBikes[index];
              final data = bikeDoc.data() as Map<String, dynamic>? ?? {};
              final dynamic pickupDate = data['pickupDate'];
              final dynamic pickupTime = data['pickupTime'];
              final dynamic handoverDate = data['handoverDate'];
              final dynamic handoverTime = data['handoverTime'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bike: ${data['name'] ?? 'Unknown'}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Price: ${data['price'] ?? '0'}", style: const TextStyle(fontSize: 16, color: Colors.green)),
                      const SizedBox(height: 8),
                      Text("Pickup Date: ${formatTime(pickupDate)}"),
                      Text("Pickup Time: ${formatTime(pickupTime)}"),
                      Text("Handover Date: ${formatTime(handoverDate)}"),
                      Text("Handover Time: ${formatTime(handoverTime)}"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: const Text("View Details",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Historyfulldetails(bookingId: bikeDoc.id,
                                      data: data)
                                ),
                              );
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
    );
  }
}