import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rngs/Bike_rental/Bike_rental.dart';
import 'package:rngs/Cart.dart';
import 'package:rngs/Home.dart';
import 'package:rngs/More/more.dart';
import 'package:rngs/Process/process.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomBar extends StatefulWidget {
  State<BottomBar> createState() => bottomState();
}

class bottomState extends State<BottomBar> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int selectedPage = 2;

  final List<Widget> module = [
    BikeRental(),
    CartPage(),
    Home(),
    Process(),
    More(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: selectedPage,
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Image.asset(
              'assets/img/booking.png',
              width: 24,
              height: 24,
            ),
            title: Text('Bike rental',style: TextStyle(fontSize: 13),),
            selectedColor: Colors.pinkAccent,
          ),
          SalomonBottomBarItem(
            icon: Image.asset(
              'assets/img/motorcycle.png',
              width: 24,
              height: 24,
            ),
            title: Text('Cart',style: TextStyle(fontSize: 13)),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 4,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/img/main_logo.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),
            title: Text('RideNGo',style: TextStyle(fontSize: 13)),
            selectedColor: Colors.red,
          ),
          SalomonBottomBarItem(
            icon: Image.asset(
              'assets/img/process.png',
              width: 24,
              height: 24,
            ),
            title: Text('Process',style: TextStyle(fontSize: 13)),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Image.asset(
              'assets/img/more.png',
              width: 24,
              height: 24,
            ),
            title: Text('More',style: TextStyle(fontSize: 13)),
            selectedColor: Colors.blue,
          ),
        ],
      ),
      body: module[selectedPage],
    );
  }
}
