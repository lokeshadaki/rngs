import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Historyfulldetails extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> data;
  const Historyfulldetails({
    Key? key,
    required this.bookingId,
    required this.data,
  }) : super(key: key);

  String formatDate(dynamic value) {
    if (value == null) return '-';
    if (value is Timestamp) {
      DateTime date = value.toDate();
      return "${date.day}/${date.month}/${date.year}";
    } else {
      return value.toString();
    }
  }

  Widget buildRow(String title, String value, {String? subText, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (subText != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subText,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Details",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('history').doc(bookingId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No booking found"));
          }

          final docData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bike: ${docData['name'] ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Pickup Location: ${docData['location'] ?? '-'}"),
                  Text("Booking Date: ${formatDate(docData['pickupDate'])}"),
                  Text("Pickup Time: ${docData['pickupTime'] ?? '-'}"),
                  Text("Handover Date: ${formatDate(docData['handoverDate'])}"),
                  Text("Handover Time: ${formatDate(docData['handoverTime'])}"),

                  const Divider(height: 30),
                  const Text("Price", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  buildRow("Total Days Booked", "${docData['totaldaysbooked'] ?? '-'} Days"),
                  buildRow("Total Hours Booked", "${docData['totalhoursbooked'] ?? '-'} Hours"),
                  buildRow("Price", "₹${docData['price'] ?? '-'}"),
                  buildRow("Total Rent", "₹${docData['totalrent'] ?? '-'}"),
                  buildRow("Refundable Deposit", "₹${docData['deposit'] ?? 0}",
                      subText: "(Returned after rental period)"),
                  buildRow("Helmet Price", "₹${docData['helmetprice'] ?? 0}",
                      subText: "(Based on booking days)"),
                  buildRow("Discount", "-₹${docData['discount'] ?? 0}",
                      textColor: const Color(0xff118B50)),
                  buildRow("Delivery Charges", "₹${docData['deliverycharge'] ?? 0}",
                      subText: "(FREE Delivery)", textColor: const Color(0xff118B50)),

                  const Divider(),
                  buildRow("Total", "₹${docData['totalAmount'] ?? '-'}", textColor: Colors.green),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
