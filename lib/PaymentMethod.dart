import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rngs/BottomBar.dart';

class PaymentMethod extends StatefulWidget {
  final String username;
  final String selectedBike;
  final double bikePrice;
  final double rent;
  final double deposit;
  final double discount;
  final double deliverycharge;
  final double helmetPrice;
  final double totalRent;
  final int totalDays;
  final int totalHours;
  final String selectedLocation;
  final String bookingDate;
  final String pickupTime;
  final String handoverDate;
  final String handoverTime;

  const PaymentMethod({
    Key? key,
    required this.username,
    required this.selectedBike,
    required this.bikePrice,
    required this.rent,
    required this.deposit,
    required this.discount,
    required this.deliverycharge,
    required this.helmetPrice,
    required this.totalRent,
    required this.totalDays,
    required this.totalHours,
    required this.selectedLocation,
    required this.bookingDate,
    required this.pickupTime,
    required this.handoverDate,
    required this.handoverTime,
  }) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String _selectedPaymentMethod = "Cash on Delivery";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool showPaymentDetails = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  bool _isProcessing = false;

  Future<void> _confirmPayment() async {
    if (_user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in. Please log in first!")),
      );
      return;
    }

    final kycSnapshot = await _firestore.collection('kyc').doc(_user!.uid).get();
    if (!kycSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete KYC before booking."), backgroundColor: Colors.red),
      );
      return;
    }

    if (_selectedPaymentMethod != "Cash on Delivery") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Currently, only Cash on Delivery is available.")),
      );
      return;
    }

    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Check if the user already has an active booking
      final activeBookingSnapshot = await _firestore
          .collection("bookings")
          .where("userId", isEqualTo: _user!.uid)
          .get();

      bool hasActiveBooking = activeBookingSnapshot.docs.any((doc) {
        // Consider any booking not yet completed as active
        return doc.exists && !(doc.data()['isEnded'] ?? false);
      });

      if (hasActiveBooking) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You already have an active booking. Please complete or cancel it before booking another.")),
        );
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      String customBookingId = "${_user!.uid}_${widget.bookingDate}_${widget.pickupTime}_${DateTime.now().millisecondsSinceEpoch}";

      DocumentSnapshot existingBooking = await _firestore.collection("bookings").doc(customBookingId).get();
      if (existingBooking.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking already exists. Please try again.")),
        );
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      int startotp = Random().nextInt(900000) + 100000;
      int endotp = Random().nextInt(900000) + 100000;
      DocumentReference bookingRef = _firestore.collection("bookings").doc(customBookingId);

      await bookingRef.set({
        'bookingId': customBookingId,
        'username': widget.username,
        'userId': _user!.uid,
        'name': widget.selectedBike,
        'price': widget.bikePrice,
        'totalrent': widget.rent,
        'location': widget.selectedLocation,
        'pickupDate': widget.bookingDate,
        'pickupTime': widget.pickupTime,
        'handoverDate': widget.handoverDate,
        'handoverTime': widget.handoverTime,
        'totaldaysbooked': widget.totalDays,
        'totalhoursbooked': widget.totalHours,
        'totalAmount': widget.totalRent,
        'deposit': widget.deposit,
        'discount': widget.discount,
        'deliverycharge': widget.deliverycharge,
        'helmetprice': widget.helmetPrice,
        'paymentMethod': _selectedPaymentMethod,
        'paymentStatus': "Pending",
        'timestamp': FieldValue.serverTimestamp(),
        'startotp': startotp,
        'endotp': endotp,
        'isStarted': false,
        'isEnded': false, // Important to track completion
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking Confirmed!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Payment Method", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0XFF3E5879).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    if (showPaymentDetails)
                      Column(
                        children: [
                          buildRow("Total Days Booked", "${widget.totalDays} Days"),
                          buildRow("Total Hours Booked", "${widget.totalHours} Hours"),
                          buildRow("Price", "₹${widget.bikePrice}"),
                          buildRow("Total Rent", "₹${widget.rent}"),
                          buildRow("Refundable Deposit", "₹${widget.deposit}",
                              subText: "(Returned after rental period)"),
                          buildRow("Helmet Price", "₹${widget.helmetPrice}",
                              subText: "(Based on booking days)"),
                          buildRow("Discount", "-₹${widget.discount}",
                              textColor: Color(0xff118B50)),
                          buildRow("Delivery Charges", "₹${widget.deliverycharge}",
                              subText: "(FREE Delivery)", textColor: Color(0xff118B50)),
                          SizedBox(height: 8),
                          Divider(color: Colors.grey.withOpacity(0.5)),
                          SizedBox(height: 8),
                        ],
                      ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPaymentDetails = !showPaymentDetails;
                        });
                      },
                      child: Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Total Amount",
                                  style: TextStyle(color: Color(0xff213555), fontSize: 16),
                                ),
                                Icon(
                                  showPaymentDetails
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xff213555),
                                  size: 25,
                                ),
                              ],
                            ),
                            Text(
                              "₹${widget.totalRent}",
                              style: TextStyle(
                                  color: Color(0xff213555),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 13),
            //Alert Message
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red.withOpacity(0.2),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Currently, only Cash on Delivery (COD) is available.",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            buildRadioTile("Cash on Delivery"),
            buildRadioTile("UPI"),
            buildRadioTile("Credit/Debit Card"),
            buildRadioTile("Net Banking"),
            buildRadioTile("Wallet"),
            SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Confirm Payment",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String title, String value, {String? subText, Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 15)),
              if (subText != null)
                Text(subText, style: TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 15, color: textColor)),
        ],
      ),
    );
  }

  Widget buildRadioTile(String method) {
    return RadioListTile(
      title: Text(method, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      value: method,
      groupValue: _selectedPaymentMethod,
      activeColor: Colors.black87,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value.toString();
        });
      },
    );
  }
}
