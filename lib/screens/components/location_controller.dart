import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class AddressSearchBar extends StatefulWidget {
  final Function(String address, double lat, double lng) onPlaceSelected;

  const AddressSearchBar({
    super.key, 
    required this.onPlaceSelected
  });
   
  @override
  State<AddressSearchBar> createState() => _AddressSearchBarState();
}

class _AddressSearchBarState extends State<AddressSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final String apiKey = 'GOOGLE_MAPS_API_KEY'; // <!--GOOGLE_MAPS_API_KEY-->

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: _controller,
        googleAPIKey: apiKey,
        inputDecoration: InputDecoration(
          fillColor: Colors.white,
          hintText: "Search address",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        debounceTime: 400,
        countries: const ["ca", "us"], // restrict to specific countries
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          if (prediction.lat != null && prediction.lng != null) {
            widget.onPlaceSelected(
              prediction.description ?? '',
              double.parse(prediction.lat!),
              double.parse(prediction.lng!),
            );
          }
        },
        itemClick: (Prediction prediction) {
          _controller.text = prediction.description ?? '';
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
