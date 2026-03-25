import 'package:rngs/Bike_rental/Bike_rental.dart';
import 'package:rngs/Cart.dart';
import 'package:rngs/Home.dart';
import 'package:rngs/More/more.dart';
import 'package:flutter/material.dart';

class Process extends StatefulWidget {
  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  final List<Widget> module=[
    BikeRental(),
    CartPage(),
    Home(),
    Process(),
    More(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Process",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: [
          buildStep(
            icon: Icons.check_circle,
            text: 'Select from the list of bikes/scooters',
            color: Colors.white,
            tileColor: Colors.black87,
          ),
          buildConnector(),
          buildStep(
            icon: Icons.calendar_today,
            text: 'Select date & pickup location',
            color: Colors.green,
            tileColor: Colors.black87, // Tile background color
          ),
          buildConnector(),
          buildStep(
            icon: Icons.description,
            text: 'Submit KYC documents',
            color: Colors.redAccent,
            tileColor: Colors.black87,
          ),
          buildConnector(),
          buildStep(
            icon: Icons.payment,
            text: 'Pay & book the bike',
            color: Colors.purpleAccent,
            tileColor: Colors.black87,
          ),
          buildConnector(),
          buildStep(
            icon: Icons.motorcycle,
            text: 'Enjoy the ride',
            color: Colors.cyan,
            tileColor: Colors.black87,
          ),
        ],
      ),
    ),
    );
  }

  Widget buildStep({required IconData icon, required String text, required Color color, Color tileColor = Colors.grey}) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        color: tileColor,
        border: Border.all(width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConnector() {
    return Container(
      height: 40.0,
      child: VerticalDivider(
        color: Colors.black87,
        thickness: 2,
      ),
    );
  }
}
