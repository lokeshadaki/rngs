import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rngs/BookingDetails.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
        title: const Text("My Cart", style: TextStyle(color: Colors.black)),
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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bikes booked yet!"));
          }

          final bookedBikes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookedBikes.length,
            itemBuilder: (context, index) {
              final bikeDoc = bookedBikes[index];
              final data = bikeDoc.data() as Map<String, dynamic>? ?? {};
              print("Booking Data: $data"); // Debugging

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bike: ${data['name'] ?? 'Unknown'}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Price: ${data['price'] ?? '0'}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Text("Total Amount: ${data['totalAmount'] ?? '0'}",
                        style: const TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),),
                      const SizedBox(height: 8),
                      Text("Pickup Location: ${data['location'] ?? '-'}"),
                      Text("Booking Date: ${data['pickupDate'] != null
                          ? formatDate(data['pickupDate'])
                          : '-'}"),
                      Text("Pickup Time: ${data['pickupTime'] != null
                          ? formatTime(data['pickupTime'])
                          : '-'}"),
                      Text("Handover Date: ${data['handoverDate'] != null
                          ? formatDate(data['handoverDate'])
                          : '-'}"),
                      Text("Handover Time: ${data['handoverTime'] != null
                          ? formatTime(data['handoverTime'])
                          : '-'}"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (data['isStarted'] != true)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Cancel Booking", style: TextStyle(color: Colors.white)),
                              onPressed: () async {
                                int otp = Random().nextInt(900000) + 100000;
                                String enteredOtp = "";

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('OTP: $otp')),
                                );

                                final result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Cancel Booking"),
                                      content: TextField(
                                        maxLength: 6,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          enteredOtp = value;
                                        },
                                        decoration: const InputDecoration(hintText: "Enter 6-digit OTP"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text("Ok"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  if (enteredOtp == otp.toString()) {
                                    await _firestore.collection('bookings').doc(bikeDoc.id).delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Booking removed')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid OTP')),
                                    );
                                  }
                                }
                              },
                            )
                          else
                          // Show "Enjoy your ride" if booking has started and cancel is disabled
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Enjoy your ride 🚴‍♂️",
                                    style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text("View Full Details", style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingDetailsPage(
                                    data: data,
                                    bookingId: bikeDoc.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
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