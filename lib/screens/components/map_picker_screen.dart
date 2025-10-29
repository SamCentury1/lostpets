import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/components/location_controller.dart';
import 'package:tempoct2025/settings/settings.dart';

class MapPickerScreen extends StatefulWidget {
  final String? petId;
  final Function onPressed;
  const MapPickerScreen({
    super.key,
    required this.petId,
    required this.onPressed
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



  @override
  void dispose() {
    if (mounted) {
      try {
        _controller!.dispose();
      } catch (_) {
        // ignore if controller not yet created
      }
    }
    super.dispose();
  }


  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString('assets/json/map_style.json');
    setState(() {
      _mapStyle = style;
    });
  }  

  GoogleMapController? _mapController;
  LatLng _target = const LatLng(45.5017, -73.5673); // default Montreal

  void _onPlaceSelected(String address, double lat, double lng) {
    setState(() {
      // _target = LatLng(lat, lng);
      _selectedPosition = LatLng(lat, lng);
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_target, 15),
    );
  }

  Future<String?> getLocationText(LatLng? selectedLocation) async {
    String? res = null;
    if (selectedLocation != null) {
      final GeoPoint newLocation = GeoPoint(selectedLocation!.latitude, selectedLocation!.longitude);
      res = await Helpers().getAddressFromGeoPoint2(newLocation);
    }
    return res;
  }  



  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context,appState,child) {
        return Scaffold(
          appBar: AppBar(title: Text("Select Location")),
          body: Stack(
            children: [
              GoogleMap(
                style: _mapStyle,
                initialCameraPosition: CameraPosition(
                  target: LatLng(45.5017, -73.5673), // Default: Montreal
                  zoom: 10,
                ),
                onMapCreated: (controller) => _controller = controller,
                // onTap: (LatLng pos) {
                //   setState(() {
                //     _selectedPosition = pos;
                //   });
                // },
                markers: _selectedPosition == null
                    ? {}
                    : {
                        Marker(
                          markerId: MarkerId("selected"),
                          position: _selectedPosition!,
                        ),
                      },
              ),

              Positioned(
                top: 16,
                left: 12,
                right: 12,
                child: AddressSearchBar(onPlaceSelected: _onPlaceSelected),
              ),              
            ],
          ),
          floatingActionButton: _selectedPosition != null
              ? FloatingActionButton.extended(

                  onPressed: () => widget.onPressed(appState,_selectedPosition),
                  
                  // onPressed: () async {
                  //   // ✅ Save to Firestore
                  //   // FirebaseFirestore.instance.collection('pets').doc(petId).update({
                  //   //   'location': GeoPoint(_selectedPosition!.latitude, _selectedPosition!.longitude)
                  //   // });

                  //   // if (widget.petId!=null) {
                  //   final newLocation = GeoPoint(_selectedPosition!.latitude, _selectedPosition!.longitude);
                  //   //   FirestoreMethods().updatePetLocation(widget.petId!,newLocation);
                  //   //   Helpers().updatePetLocationToSettings(settings, widget.petId!, newLocation);
                  //   // }
                  //   Map<String,dynamic> petObject = appState.newPetObject;
                  //   petObject.update("location", (v)=> newLocation);
                  //   appState.setNewPetObject(petObject);
        
                  //   print("new position: LONG:${_selectedPosition!.longitude} LAT:${_selectedPosition!.latitude}");
        
                  //   Navigator.pop(context);
                  // },
                  label: FutureBuilder(
                    future: getLocationText(_selectedPosition),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading Address...");
                      } else if (asyncSnapshot.hasError) {
                        debugPrint(asyncSnapshot.error.toString());
                        return Text("Error getting address");
                      } else if (asyncSnapshot.hasData) {
                        return Text("Save Location: \n ${asyncSnapshot.data}");
                      } else {
                        return Text("Address");
                      }
                    }
                  ),
                  icon: Icon(Icons.check),
                )
              : null,
        );
      }
    );
  }
}