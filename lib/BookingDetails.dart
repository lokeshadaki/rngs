import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingDetailsPage extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> data;
  const BookingDetailsPage({
    Key? key,
    required this.bookingId,
    required this.data
  }) : super(key: key);

  // Formatter
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
        title: const Text("Booking Details"),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings') // your collection name
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No booking found"));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bike: ${data['name'] ?? 'Unknown'}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Pickup Location: ${data['location'] ?? '-'}"),
                  Text("Booking Date: ${formatDate(data['bookingDate'])}"),
                  Text("Pickup Time: ${data['pickupTime'] ?? '-'}"),
                  Text("Handover Date: ${formatDate(data['handoverDate'])}"),
                  Text("Handover Time: ${data['handoverTime'] ?? '-'}"),

                  const Divider(height: 30),
                  const Text("Price", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  buildRow("Total Days Booked", "${formatDate(data['totaldaysbooked'])} Days"),
                  buildRow("Total Hours Booked", "${data['totalhoursbooked'] ?? '-'} Hours"),
                  buildRow("Price", "₹${data['price'] ?? '-'}"),
                  buildRow("Total Rent", "₹${data['totalrent'] ?? '-'}"),
                  buildRow("Refundable Deposit", "₹${data['deposit']}", subText: "(Returned after rental period)"),
                  buildRow("Helmet Price", "₹${data['helmetprice']}", subText: "(Based on booking days)"),
                  buildRow("Discount", "-₹${data['discount']}", textColor: const Color(0xff118B50)),
                  buildRow("Delivery Charges", "₹${data['deliverycharge']}", subText: "(FREE Delivery)", textColor: const Color(0xff118B50)),
                  const SizedBox(height: 10),
                  const Divider(),
                  buildRow("Total", "₹${data['totalAmount']}", textColor: Colors.green),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
