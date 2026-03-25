import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rngs/Location_model.dart';
class Locationpage extends StatefulWidget {
  const Locationpage({Key? key}) : super(key: key);
  @override
  _LocationState createState() => _LocationState();
}
class _LocationState extends State<Locationpage> {
  // Main list of locations
  static List<LocationModel> Main_location_list = [
    LocationModel("Bengaluru", "assets/img/bengaluru.jpeg"),
    LocationModel("Goa", "assets/img/GOA.jpg"),
    LocationModel("Delhi", "assets/img/delhi.jpg"),
    LocationModel("Hydrabad", "assets/img/hydrabad.jpg"),
    LocationModel("Mumbai", "assets/img/mumbai.jpg"),
    LocationModel("solapur", "assets/img/solapur1.jpg"),
  ];
  // Display list for search results
  List<LocationModel> display_list = List.from(Main_location_list);

  // Update the list based on the search query
  void updateList(String value) {
    setState(() {
      display_list = Main_location_list
          .where((location) =>
          location.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              "Search for a city",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                fillColor: Colors.grey[2],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "e.g., Solapur",
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
              ),
              onChanged: (value)=>updateList(value),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.builder(
                itemCount: display_list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: SizedBox(
                            child: Center(
                              child: Text("Feature is coming soon !!!"),
                            ),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[10],
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(display_list[index].photoPath!),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.grey,
                                width: 3.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // City Name
                          Text(
                            display_list[index].name!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
