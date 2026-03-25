import 'package:flutter/material.dart';
import 'MapPage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rngs/PaymentMethod.dart';

class BookingPage extends StatefulWidget {
  final String selectedBike;
  final String bikePrice;
  final String bikeImage;
  const BookingPage({Key? key,
    required this.selectedBike,
    required this.bikePrice,
    required this.bikeImage
  }) : super(key: key);

  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? username;
  String _locationText = "Select Location";
  String? _selectedLocation;
  DateTime? _selectedBookingDate;
  TimeOfDay? _selectedbookingTime;
  DateTime? _selectedHandoverDate;
  TimeOfDay? _selectedhandoverTime;
  DateTime? _bookingDateTime;
  DateTime? _handoverDateTime;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _nameController.text = "${userDoc['firstName']} ${userDoc['lastName']}";
          _mobileController.text = userDoc['mobile'];
          username = _nameController.text;
        });
      }
    }
  }

  void _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage()),
    );
    if (result != null) {
      setState(() {
        _selectedLocation = result['place'];
        _locationText = result['place'];
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _selectedBookingDate = pickedDate;

          if (_selectedHandoverDate != null &&
              _selectedHandoverDate!.isBefore(_selectedBookingDate!)) {
            _selectedHandoverDate = null;
          }

          if (_selectedbookingTime != null) {
            _bookingDateTime = DateTime(
              _selectedBookingDate!.year,
              _selectedBookingDate!.month,
              _selectedBookingDate!.day,
              _selectedbookingTime!.hour,
              _selectedbookingTime!.minute,
            );
          }
        } else {
          if (_selectedBookingDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a booking date first!")),
            );
            return;
          }
          if (pickedDate.isBefore(_selectedBookingDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Handover date must be after booking date!")),
            );
            return;
          }

          _selectedHandoverDate = pickedDate;

          if (_selectedhandoverTime != null) {
            _handoverDateTime = DateTime(
              _selectedHandoverDate!.year,
              _selectedHandoverDate!.month,
              _selectedHandoverDate!.day,
              _selectedhandoverTime!.hour,
              _selectedhandoverTime!.minute,
            );
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay initialTime;
    DateTime now = DateTime.now();

    if (isStartTime) {
      // If booking date is today, apply 30-minute rule
      if (_selectedBookingDate != null &&
          _selectedBookingDate!.year == now.year &&
          _selectedBookingDate!.month == now.month &&
          _selectedBookingDate!.day == now.day) {
        DateTime adjustedNow = now.add(Duration(minutes: 30));
        initialTime = TimeOfDay(hour: adjustedNow.hour, minute: adjustedNow.minute);
      } else {
        initialTime = TimeOfDay(hour: 12, minute: 0); // default for future dates
      }
    } else {
      initialTime = TimeOfDay(hour: 12, minute: 0); // default handover time
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _selectedbookingTime = pickedTime;

          if (_selectedBookingDate != null) {
            _bookingDateTime = DateTime(
              _selectedBookingDate!.year,
              _selectedBookingDate!.month,
              _selectedBookingDate!.day,
              pickedTime.hour,
              pickedTime.minute,
            ).toUtc();
          }
        } else {
          _selectedhandoverTime = pickedTime;

          if (_selectedHandoverDate != null) {
            _handoverDateTime = DateTime(
              _selectedHandoverDate!.year,
              _selectedHandoverDate!.month,
              _selectedHandoverDate!.day,
              pickedTime.hour,
              pickedTime.minute,
            ).toUtc();
          }
        }
      });
    }
  }


  void _confirmBooking() async {
    String name = _nameController.text.trim();
    String phone = _mobileController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name and phone number!")),
      );
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 10-digit mobile number!")),
      );
      return;
    }

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a location first!")),
      );
      return;
    }

    if (_selectedBookingDate == null || _selectedHandoverDate == null ||
        _selectedbookingTime == null || _selectedhandoverTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both booking and handover dates & times!")),
      );
      return;
    }

    DateTime bookingDateTime = DateTime(
      _selectedBookingDate!.year,
      _selectedBookingDate!.month,
      _selectedBookingDate!.day,
      _selectedbookingTime!.hour,
      _selectedbookingTime!.minute,
    );

    DateTime handoverDateTime = DateTime(
      _selectedHandoverDate!.year,
      _selectedHandoverDate!.month,
      _selectedHandoverDate!.day,
      _selectedhandoverTime!.hour,
      _selectedhandoverTime!.minute,
    );

    if (handoverDateTime.isBefore(bookingDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Handover must be after booking time!")),
      );
      return;
    }

    Duration duration = handoverDateTime.difference(bookingDateTime);
    int totalHours = duration.inHours;
    if (duration.inMinutes % 60 != 0) {
      totalHours += 1;
    }

    double helmetPricePerDay = 19.0;
    int totalDays = (totalHours / 24).ceil();
    double helmetPrice = helmetPricePerDay * totalDays;

    String numericPrice = widget.bikePrice.replaceAll(RegExp(r'[^\d.]'), '');
    double pricePerDay = double.parse(numericPrice);
    double pricePerHour = pricePerDay / 24;

    double calculatedPrice = pricePerHour * totalHours;

    double deposit = 1500.0;
    double discount = 50.0;
    double deliveryCharge = 0.0;

    double totalRent = calculatedPrice - discount + helmetPrice + deposit + deliveryCharge;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Proceed to Payment")),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethod(
          username: username ?? '',
          selectedBike: widget.selectedBike,
          bikePrice: pricePerDay,
          bookingDate: _selectedBookingDate?.toIso8601String() ?? '',
          pickupTime: _selectedbookingTime?.format(context) ?? '',
          handoverDate: _selectedHandoverDate?.toIso8601String() ?? '',
          handoverTime: _selectedhandoverTime?.format(context) ?? '',
          rent: calculatedPrice,
          deposit: deposit,
          discount: discount,
          deliverycharge: deliveryCharge,
          helmetPrice: helmetPrice,
          totalDays: totalDays,
          totalRent: totalRent,
          totalHours: totalHours,
          selectedLocation: _locationText,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Your Ride")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(widget.bikeImage, height: 180,),
            ),
            SizedBox(height: 20),
            Text(" Bike: ${widget.selectedBike}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(" Price: ${widget.bikePrice}", style: TextStyle(fontSize: 16, color: Colors.green)),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Mobile Number", border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            Text("Select Location"),
            InkWell(
              onTap: _pickLocation,
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 15),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(_locationText, style: TextStyle(fontSize: 16)),
              ),
            ),
            Text("Booking Date"),
            ListTile(
              title: Text(_selectedBookingDate == null ? "Select Date" : DateFormat.yMMMd().format(_selectedBookingDate!)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            Text("Booking Time"),
            ListTile(
              title: Text(_selectedbookingTime == null ? "Select Time" : _selectedbookingTime!.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            Text("Handover Date"),
            ListTile(
              title: Text(_selectedHandoverDate == null ? "Select Date" : DateFormat.yMMMd().format(_selectedHandoverDate!)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            Text("Handover Time"),
            ListTile(title: Text(_selectedhandoverTime == null ? "Select Time" : _selectedhandoverTime!.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
            ),
            SizedBox(height: 20),

            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text("Confirm Booking", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}