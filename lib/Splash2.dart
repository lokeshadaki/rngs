import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rngs/BottomBar.dart';
import 'package:rngs/Home.dart';

class Splash2 extends StatefulWidget {
  @override
  State<Splash2> createState() => _SplashState();
}

class _SplashState extends State<Splash2> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/RideNGo.gif"),
            fit: BoxFit.contain,
            scale: 0.5,
            alignment: Alignment.center,
          ),
        ),

      ),
    );
  }
}