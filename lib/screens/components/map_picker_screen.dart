import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _selectedPosition;
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(45.5017, -73.5673), // Default: Montreal
          zoom: 10,
        ),
        onMapCreated: (controller) => _controller = controller,
        onTap: (LatLng pos) {
          setState(() {
            _selectedPosition = pos;
          });
        },
        markers: _selectedPosition == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId("selected"),
                  position: _selectedPosition!,
                ),
              },
      ),
      floatingActionButton: _selectedPosition != null
          ? FloatingActionButton.extended(
              onPressed: () async {
                // ✅ Save to Firestore
                // FirebaseFirestore.instance.collection('pets').doc(petId).update({
                //   'location': GeoPoint(_selectedPosition!.latitude, _selectedPosition!.longitude)
                // });

                Navigator.pop(context);
              },
              label: Text("Save Location"),
              icon: Icon(Icons.check),
            )
          : null,
    );
  }
}