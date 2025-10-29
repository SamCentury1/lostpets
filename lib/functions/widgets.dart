import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class Widgets {
  Widget vaccinesWidget(BuildContext context, List<dynamic> vaccines,) {

    TextStyle _textStyle =TextStyle(
      fontFamily: 'monospace',
      fontFeatures: [FontFeature.tabularFigures()],
      letterSpacing: 1.0
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Vaccines: ",
                style: _textStyle
              ),
            ),
          ),
          Expanded(
            flex: 4,
              child: vaccines .isEmpty
              ? Text("No vaccines", style: _textStyle,)
              : Column(
                children: vaccines.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Row(
                      children: [
                        Text(
                          "${e["vaccine"]} (${e["year"]})",
                          style: _textStyle,
                        )
                      ],
                    ),
                  );
                }).toList(),

              ),
          ),
        ],
      ),
    );   
  }


  Widget diseasesWidget(BuildContext context, List<dynamic> diseases,) {

    TextStyle _textStyle =TextStyle(
      fontFamily: 'monospace',
      fontFeatures: [FontFeature.tabularFigures()],
      letterSpacing: 1.0
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Diseases: ",
                style: _textStyle
              ),
            ),
          ),
          Expanded(
            flex: 4,
              child: diseases .isEmpty
              ? Text("No Diseases", style: _textStyle,)
              : Column(
                children: diseases.map((e) {
                  print(e);
                  String contagious = "contagious";
                  if (!e["contagious"]) {
                    contagious = "not contagious";
                  }                  
                  return Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Row(
                      children: [
                          Text("${e["disease"]} ($contagious)",style: _textStyle,),
                      ],
                    ),
                  );
                }).toList(),

              ),
          ),
        ],
      ),
    );       
  }

  Widget petProfileAttributeRow(String attributeBody, String valueBody) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              attributeBody,
              style: TextStyle(
                fontFamily: 'monospace',
                fontFeatures: [FontFeature.tabularFigures()],
                letterSpacing: 1.0
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              valueBody,
              style: TextStyle(
                fontFamily: 'monospace',
                fontFeatures: [FontFeature.tabularFigures()],
                letterSpacing: 1.0
              ),
            ),
          ),
        ],
      ),
    );   

  }
  Future<BitmapDescriptor> createCircularMarker(String? imageUrl, {int size = 100}) async {
    if (imageUrl != null && imageUrl != "") {
      final response = await http.get(Uri.parse(imageUrl));
      final Uint8List imageData = response.bodyBytes;

      final ui.Codec codec = await ui.instantiateImageCodec(imageData, targetWidth: size);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint()..isAntiAlias = true;

      final double radius = size / 2.0;
      final Rect rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

      canvas.clipPath(Path()..addOval(rect));
      canvas.drawImageRect(frameInfo.image, Rect.fromLTWH(0, 0, frameInfo.image.width.toDouble(), frameInfo.image.height.toDouble()), rect, paint);

      final ui.Image circularImage = await recorder
          .endRecording()
          .toImage(size, size);
      final ByteData? byteData = await circularImage.toByteData(format: ui.ImageByteFormat.png);
      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } else {
      return BitmapDescriptor.pinConfig(backgroundColor: Colors.black);
    }
  }

  
}