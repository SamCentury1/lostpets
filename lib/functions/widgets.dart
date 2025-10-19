import 'package:flutter/material.dart';

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

  
}