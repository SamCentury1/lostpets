import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tempoct2025/functions/widgets.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

class PetMapScreen extends StatefulWidget {
  final Map<String,dynamic>? petObject;
  const PetMapScreen({
    super.key,
    required this.petObject
  });

  @override
  State<PetMapScreen> createState() => _PetMapScreenState();
}

class _PetMapScreenState extends State<PetMapScreen> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  String? _mapStyle = '';


  Future<void> _ensureLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return; // Permissions still denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions permanently denied
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _ensureLocationPermission();
    loadPets();
    _loadMapStyle();
  }




  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString('assets/json/map_style.json');
    setState(() {
      _mapStyle = style;
    });
  }

  Future<void> loadPets() async {
    late List<Map<String,dynamic>> pets = [];
    if (widget.petObject != null) {
      pets = [widget.petObject!];
    } else {
      pets = await FirestoreMethods().fetchPetLocations();
    }
    
    Set<Marker> markers = {};

    for (final pet in pets) {
      final icon = await Widgets().createCircularMarker(pet["displayUrl"], size: 120);
      markers.add(
        Marker(
          markerId: MarkerId(pet["uid"]),
          position: LatLng(
            pet["location"]["latitude"],
            pet["location"]["longitude"],
          ),
          icon: icon,
          onTap: () => _showPetDetails(context, pet),
        ),
      );    
    }
    setState(() => _markers.addAll(markers));
  }



  Future<void> _goToLocation(Map<String,dynamic>? petObject, GoogleMapController controller) async {

    late LatLng endPosition = LatLng(0, 0);

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (petObject != null) {
      endPosition = LatLng(petObject["location"].latitude, petObject["location"].longitude); 
    } else {
      endPosition = LatLng(position.latitude, position.longitude);
    }

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: endPosition,
          zoom: 15,
        ),
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // return Scaffold(
          // appBar: AppBar(title: Text("Pet Map")),
          if (_mapStyle == null) {
            return Center(child: CircularProgressIndicator());
          } else {
              return GoogleMap(
                onMapCreated: (controller) {
                  _controller = controller;
                  _goToLocation(widget.petObject, controller);
                } ,
                style: _mapStyle, // 👈 NEW way to apply style
                initialCameraPosition: const CameraPosition(
                  target: LatLng(45.510, -73.679),
                  zoom: 11,
                ),
                markers: _markers,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                myLocationButtonEnabled: true,            
              );            
          }
          // body: _mapStyle == null
          //   ? const Center(child: CircularProgressIndicator())
          //   : GoogleMap(
          //       onMapCreated: (controller) {
          //         _controller = controller;
          //         _goToLocation(widget.petObject, controller);
          //       } ,
          //       style: _mapStyle, // 👈 NEW way to apply style
          //       initialCameraPosition: const CameraPosition(
          //         target: LatLng(45.510, -73.679),
          //         zoom: 11,
          //       ),
          //       markers: _markers,
          //       myLocationEnabled: true,
          //       zoomControlsEnabled: true,
          //       zoomGesturesEnabled: true,
          //       scrollGesturesEnabled: true,
          //       rotateGesturesEnabled: true,
          //       tiltGesturesEnabled: true,
          //       myLocationButtonEnabled: true,            
          //     ),
        // );
      }
    );
  }
}

void _showPetDetails(BuildContext context, Map<String, dynamic> pet) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                pet["displayUrl"],
                height: 300,
                width: 400,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pet["name"] ?? "Unknown Pet",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (pet["description"] != null) ...[
              const SizedBox(height: 8),
              Text(pet["description"]),
            ],
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
