import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBookingDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  const AdminBookingDetails({required this.data, Key? key}) : super(key: key);

  String formatDate(dynamic value) {
    if (value == null) return '-';
    if (value is Timestamp) {
      DateTime date = value.toDate();
      return "${date.day}/${date.month}/${date.year}";
    }
    return value.toString();
  }

  String formatTime(dynamic value) {
    if (value == null) return '-';
    if (value is Timestamp) {
      DateTime date = value.toDate();
      return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    }
    return value.toString();
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
      appBar: AppBar(title: Text("Booking Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Bike: ${data['name'] ?? 'Unknown'}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Pickup Location: ${data['location'] ?? '-'}"),
            Text("Booking Date: ${formatDate(data['pickupDate'])}"),
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
  }
}
