import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    // rootBundle.loadString('assets/map_style.json').then((style) {
    //   _mapStyle = style;
    // });
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

    // print("VIEW ALL PETS: ${pets[0]["location"].longitude}");
    setState(() {
      _markers.addAll(
        pets.map(
          (pet) {
            print("pet: $pet");
            return Marker(
              markerId: MarkerId(pet["uid"]),
              // position: LatLng(pet["latitude"], pet["longitude"]),
              position: LatLng(pet["location"]["latitude"], pet["location"]["longitude"]),
              infoWindow: InfoWindow(title: pet["name"]),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            );
          }
      ));
    });
  }


  // Future<void> _goToUserLocation(GoogleMapController controller) async {
  //   final position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(position.latitude, position.longitude),
  //         zoom: 15,
  //       ),
  //     ),
  //   );
  // }

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
    // return Scaffold(

    //   body: _mapStyle == null
    //       ? const Center(child: CircularProgressIndicator())
    //       : GoogleMap(
    //         onMapCreated: (controller) => _controller = controller,
    //           style: _mapStyle, // 👈 NEW way to apply style
    //           initialCameraPosition: const CameraPosition(
    //             target: LatLng(45.510, -73.679),
    //             zoom: 11,
    //           ),
    //           markers: _markers,
    //           myLocationEnabled: true,
    //           zoomControlsEnabled: true,
    //           zoomGesturesEnabled: true,
    //           scrollGesturesEnabled: true,
    //           rotateGesturesEnabled: true,
    //           tiltGesturesEnabled: true,
    //         ),
    // );
    return Scaffold(
      appBar: AppBar(title: Text("Pet Map")),
      body: _mapStyle == null
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
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
          ),
    );
  }
}