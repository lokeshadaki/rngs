import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart' show Distance;

class Homestations extends StatefulWidget {
  @override
  _HomestationsState createState() => _HomestationsState();
}

class _HomestationsState extends State<Homestations> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  LatLng? _nearestStation;
  String _selectedLocation = "Fetching address...";
  double? _distanceInKm;
  bool _isLoading = true;

  final List<LatLng> _bikeStations = [
    LatLng(17.6644, 75.8930), //solapur railway stations latlng
    LatLng(17.6814, 75.8980), // solapur bus stations latlng
    LatLng(17.625862, 75.930717), // solapur airport stations latlng
    LatLng(17.6686, 75.9228) // solapur co-operation office
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      setState(() => _isLoading = true);

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng current = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = current;
        _isLoading = false;
      });

      _mapController.move(current, 14.0);
      _getAddressFromLatLng(current);
      _findNearestStation(current);
    } catch (e) {
      print("Error getting location: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _selectedLocation =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        _selectedLocation = "Failed to get address";
      });
    }
  }

  void _findNearestStation(LatLng current) {
    final Distance distance = Distance();
    double minDistance = double.infinity;
    LatLng? nearest;

    for (LatLng station in _bikeStations) {
      double km = distance.as(LengthUnit.Kilometer, current, station);
      if (km < minDistance) {
        minDistance = km;
        nearest = station;
      }
    }

    setState(() {
      _nearestStation = nearest;
      _distanceInKm = minDistance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Station"), backgroundColor: Colors.white),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentLocation ?? LatLng(17.6686, 75.9228),
              zoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (_currentLocation != null && _nearestStation != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [_currentLocation!, _nearestStation!],
                      strokeWidth: 4.0,
                      color: Colors.blue.withOpacity(0.7),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(Icons.person_pin_circle, size: 40, color: Colors.green),
                    ),
                  for (LatLng station in _bikeStations)
                    Marker(
                      point: station,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.pin_drop,
                        size: 35,
                        color: station == _nearestStation ? Colors.blue : Colors.red,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedLocation,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (_distanceInKm != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Nearest Station: ${_distanceInKm!.toStringAsFixed(2)} km",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUserLocation,
        child: Icon(Icons.my_location, color: Colors.white),
        backgroundColor: Colors.black,
      ),
    );
  }
}