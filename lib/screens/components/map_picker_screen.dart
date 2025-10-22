import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/settings/settings.dart';

class MapPickerScreen extends StatefulWidget {
  final String? petId;
  const MapPickerScreen({
    super.key,
    required this.petId
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _selectedPosition;
  GoogleMapController? _controller;
  late String? _mapStyle = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMapStyle();
  }


  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString('assets/json/map_style.json');
    setState(() {
      _mapStyle = style;
    });
  }  

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context,appState,child) {
        return Scaffold(
          appBar: AppBar(title: Text("Select Location")),
          body: GoogleMap(
            style: _mapStyle,
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

                    // if (widget.petId!=null) {
                    final newLocation = GeoPoint(_selectedPosition!.latitude, _selectedPosition!.longitude);
                    //   FirestoreMethods().updatePetLocation(widget.petId!,newLocation);
                    //   Helpers().updatePetLocationToSettings(settings, widget.petId!, newLocation);
                    // }
                    Map<String,dynamic> petObject = appState.newPetObject;
                    petObject.update("location", (v)=> newLocation);
                    appState.setNewPetObject(petObject);
        
                    print("new position: LONG:${_selectedPosition!.longitude} LAT:${_selectedPosition!.latitude}");
        
                    Navigator.pop(context);
                  },
                  label: Text("Save Location"),
                  icon: Icon(Icons.check),
                )
              : null,
        );
      }
    );
  }
}