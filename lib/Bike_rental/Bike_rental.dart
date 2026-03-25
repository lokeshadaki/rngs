import 'package:rngs/Booking/BookingPage.dart';
import 'package:rngs/Cart.dart';
import 'package:rngs/Home.dart';
import 'package:rngs/More/more.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import '../Process/process.dart';
class BikeRental extends StatefulWidget {
  @override
  _BikeRentalState createState() => _BikeRentalState();
}
class _BikeRentalState extends State<BikeRental> {

  final List<Widget> module=[
    BikeRental(),
    CartPage(),
    Home(),
    Process(),
    More(),
  ];

  bool firstSwitchValue = true;
  final List<Map<String, String>> bikes = [
    {
      "name": "Bajaj Pulsar 150",
      "image": "assets/img/bike.png",
      "price": "₹409/per day"
    },
    {
      "name": "Hero Shine 125",
      "image": "assets/img/shine.png",
      "price": "₹359/per day"
    },
  ];
  final List<Map<String, String>> scooters = [
    {
      "name": "Honda Activa",
      "image": "assets/img/activa.png",
      "price": "₹150/per day"
    },
    {
      "name": "TVS Jupiter",
      "image": "assets/img/tvs_jupiter.png",
      "price": "₹180/per day"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentList = firstSwitchValue ? bikes : scooters;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              title: Text("OUR RENTING FLEET",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context), // Fixed navigation
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: AnimatedToggleSwitch<bool>.size(
                  current: firstSwitchValue,
                  values: [false, true],
                  iconOpacity: 0.2,
                  indicatorSize: const Size.fromWidth(100),
                  customIconBuilder: (context, local, global) =>
                      Text(
                        local.value ? 'Bike' : 'Scooter',
                        style: TextStyle(color: Color.lerp(
                            Colors.black87, Colors.white,
                            local.animationValue)),
                      ),
                  borderWidth: 5.0,
                  style: ToggleStyle(
                    indicatorColor: Colors.black87,
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selectedIconScale: 1.0,
                  onChanged: (value) =>
                      setState(() => firstSwitchValue = value),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    _buildVehicleCard(context, currentList[index]),
                childCount: currentList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Map<String, String> vehicle) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(vehicle["image"] ?? "assets/img/default.png", width: 100),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle["name"] ?? "Unknown", style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("1 Day (${vehicle["price"] ?? "N/A"})",
                    style: TextStyle(color: Colors.black87)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingPage(
                              selectedBike: vehicle["name"] ?? "Unknown",
                              bikePrice: vehicle["price"] ?? "N/A",
                              bikeImage: vehicle["image"] ?? "assests/img/default.png",
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87),
                  child: Text(
                      "Book Now", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
