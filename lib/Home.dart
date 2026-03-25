import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rngs/Bike_rental/Bike_rental.dart';
import 'package:rngs/Booking/BookingPage.dart';
import 'package:rngs/Cart.dart';
import 'package:rngs/More/Kyc.dart';
import 'package:rngs/Process/process.dart';
import 'package:rngs/location.dart';
import 'package:rngs/More/more.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  _IntroState createState() => _IntroState();
}
class _IntroState extends State<Home> {
  bool firstSwitchValue = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController firstNameController=TextEditingController();
  User? _user;
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      firstNameController.text = _user!.email ?? "";
      _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('users').doc(_user!.uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          firstNameController.text = data['firstName'] ?? "";
        });
      }
    } catch (e) {
      print("Error : $e");
    }
  }

  final List<Map<String, String>> bikes = [
    {
      "name": "Bajaj Pulsar 150",
      "image": "assets/img/bike.png",
      "starting_price": "₹409/1 day",
    },
    {
      "name": "Hero Shine 125",
      "image": "assets/img/shine.png",
      "starting_price": "₹359/1 day",
    },
  ];

  final List<Map<String, String>> scooters = [
    {
      "name": "Honda Activa",
      "image": "assets/img/scooter.png",
      "price": "₹1200",
      "starting_price": "₹150/1 day",
    },
    {
      "name": "TVS Jupiter",
      "image": "assets/img/tvs_jupiter.png",
      "price": "₹1400",
      "starting_price": "₹180/1 day",
    },
  ];

  int selectedIndex = 0;
  final List<Widget> module=[
    BikeRental(),
    CartPage(),
    Home(),
    Process(),
    More(),
  ];
  bool firsSwitchvalue = false;
  String displayedImage = "assets/img/scooter.png"; // Default image path
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CustomScrollView(
        slivers: [
        SliverAppBar(
        centerTitle: true,
        floating: true,
        snap: true,
        pinned: false,
        backgroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Locationpage()),
            );
          },
          icon: Image.asset(
            'assets/img/pin.png',
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/img/main_logo.png",
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              "RideNGo",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Image.asset("assets/img/intromain.png"),
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi, ${firstNameController.text.isNotEmpty ? firstNameController.text : ''}",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "LET'S FIND A PERFECT\nRIDE FOR YOU.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )),
                        Positioned(
                          top: 20, // Distance from the top
                          right: 20, // Distance from the right
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => KycPage()),
                              );
                            },
                            icon: Container(
                              width: 80, // Button width
                              height: 80, // Button height
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white, // Background color
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 4, // Border width
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/img/kyc.png',
                                  width: 80, // Adjust image width
                                  height: 80, // Adjust image height
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(16), // Padding for the container
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color for the container
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          boxShadow: [
                            // Optional shadow for a card-like effect
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Search vehicles in your city",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Locationpage()),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200], // Corrected color value
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.black87),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Search Location eg. Solapur",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward, color: Colors.black87),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => More()), // Replace with your new page widget
                                );
                              },
                              child: Text(
                                "Want to Book a different city?",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        // Apply rounded corners
                        child: Container(
                          decoration: BoxDecoration(
                            // You can remove this decoration as the ClipRRect handles the border radius
                          ),
                          child: Image.asset(
                            "assets/img/Offer.png",
                            fit: BoxFit.cover, // Adjust image fit as needed
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Our Renting Fleet",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Animated Toggle Switch
                          AnimatedToggleSwitch<bool>.size(
                            current: firstSwitchValue,
                            values: [false, true],
                            iconOpacity: 0.2,
                            indicatorSize: const Size.fromWidth(100),
                            customIconBuilder: (context, local, global) => Text(
                              local.value ? 'Bike' : 'Scooter',
                              style: TextStyle(
                                color: Color.lerp(Colors.black87, Colors.white, local.animationValue),
                              ),
                            ),
                            borderWidth: 5.0,
                            iconAnimationType: AnimationType.onHover,
                            style: ToggleStyle(
                              indicatorColor: Colors.black87,
                              borderColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            selectedIconScale: 1.0,
                            onChanged: (value) {
                              setState(() {
                                firstSwitchValue = value;
                                selectedIndex = 0; // Reset index when switching
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // Scrollable Row to Display Multiple Bikes/Scooters
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                firstSwitchValue ? bikes.length : scooters.length,
                                    (index) {
                                  var vehicle = firstSwitchValue ? bikes[index] : scooters[index];

                                  // Ensure variables are properly assigned
                                  final selectedBike = vehicle["name"] ?? "Unknown";
                                  final bikePrice = vehicle["starting_price"] ?? "N/A";
                                  final bikeImage = vehicle["image"] ?? ""; // Default empty string to avoid null issues

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      alignment: AlignmentDirectional.topStart,
                                      height: 300,
                                      width: 175,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          // Image Container
                                          Positioned(
                                            top: 40,
                                            left: 12.5,
                                            child: Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.black87, width: 2),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.asset(
                                                  bikeImage,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Top Banner for Starting Price
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Container(
                                              width: 170,
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.purple,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "Starting at $bikePrice",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Bike/Scooter Name and Price
                                          Positioned(
                                            bottom: 50,
                                            left: 10,
                                            right: 10,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedBike,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                          ),

                                          // Book Now Button
                                          Positioned(
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => BookingPage(
                                                      selectedBike: selectedBike,
                                                      bikePrice: bikePrice,
                                                      bikeImage: bikeImage,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black87,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                "Book Now",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Why RideNGo",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 150, // Height for the horizontal list
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              // Horizontal scroll direction
                              children: [
                                Container(
                                  width:
                                  300, // Adjusted width to accommodate text properly
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.white,
                                        ),

                                        SizedBox(width: 10), // Added spacing between icon and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Freedom from Ownership Hassles",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16, color: Colors.white),
                                              ),
                                              SizedBox(
                                                  height:
                                                  5), // Spacing between title and description
                                              Text(
                                                  "Own the vehicle without owing hefty "
                                                      "down-payments, EMIs, and paperwork.",
                                                  style: TextStyle(
                                                      fontSize: 14, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                  300, // Adjusted width to accommodate text properly
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          size: 40,
                                          color: Colors.white,
                                        ),

                                        SizedBox(
                                            width:
                                            10), // Added spacing between icon and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Cost-effective",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                  height:
                                                  5), // Spacing between title and description
                                              Text(
                                                  "Budget-friendly plans for the most cost-effective daily travel",
                                                  style: TextStyle(
                                                      fontSize: 14, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                  300, // Adjusted width to accommodate text properly
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.door_back_door,
                                          color: Colors.white,
                                        ),

                                        SizedBox(
                                            width:
                                            10), // Added spacing between icon and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Stress-free travel experience.",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                  height:
                                                  5), // Spacing between title and description
                                              Text(
                                                  "Smooth rides with free monthly servicing and maintenance, delivered to your doorstep.",
                                                  style: TextStyle(
                                                      fontSize: 14, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                  300, // Adjusted width to accommodate text properly
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.motorcycle,
                                          size: 40,
                                          color: Colors.white,
                                        ),

                                        SizedBox(
                                            width:
                                            10), // Added spacing between icon and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Flexibility to pick what suits you best.",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                  height:
                                                  5), // Spacing between title and description
                                              Text(
                                                  "Choose from a range of clean and serviced vehicles with flexible plans, from a week to a year.",
                                                  style: TextStyle(
                                                      fontSize: 14, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 400,
                            height: 250,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 20,
                                    right: -80,
                                    bottom: 0,
                                    child: Image.asset(
                                      "assets/img/feature.png", // Replace with your image path
                                      width: 250, // Adjust width
                                      height: 250, // Adjust height
                                      fit: BoxFit.cover,
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  ListView(
                                    padding: EdgeInsets.only(top: 10),
                                    children: [
                                      ListTile(
                                        leading: ImageIcon(
                                          AssetImage(
                                              "assets/img/features.png"), // Path to your image
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Our Feature",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      ListTile(
                                        leading: ImageIcon(
                                          AssetImage("assets/img/f1.png"),
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Safe and Sanitised Vehicle",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15),
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.credit_card_outlined,
                                            color: Colors.white),
                                        title: Text(
                                          "Instant and Secure payments",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15),
                                        ),
                                      ),
                                      ListTile(
                                        leading: ImageIcon(
                                          AssetImage("assets/img/helmet.png"),
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Complementary Helmet",
                                          style: TextStyle(
                                            color: Colors.white, fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
