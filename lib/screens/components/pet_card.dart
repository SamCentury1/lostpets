import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/widgets.dart';
import 'package:tempoct2025/screens/pet_screen/pet_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class PetCard extends StatefulWidget {
  final Map<String,dynamic> petData;
  // final String petId;
  const PetCard({
    super.key,
    // required this.petId
    required this.petData
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {


  int calculateAge(int birthYear) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int age = currentYear-birthYear;
    return age;
  }

  String getSexSpeciesBreedText(String sex, String species, List<dynamic> breedData) {
    String res = "";
    if (breedData.isEmpty) {
      res = "$sex $species - unknown breed";
    } else if (breedData.length == 1) {
      res = "$sex $species ${breedData[0]}";
    } else if (breedData.length == 2) {
      res = "$sex $species ${breedData[0]} & ${breedData[0]} mix";
    }
    return res;
  }


  String getVaccinesText(List<dynamic> vaccines) {
    String res = "";
    if (vaccines.isEmpty) {
      res = "no vaccines";
    } else {
      for (int i=0;i<vaccines.length;i++) {
        Map<String,dynamic> vaccine = vaccines[i];
        String vaccineText = "${vaccine["vaccine"]} (${vaccine["year"]})";
        if (i<vaccines.length-1){
          res = "$res$vaccineText | ";
        } else {
          res = res + vaccineText;
        }
      }
      print(res);
    }
    return res;
  }

  String getDiseasesText(List<dynamic> diseases) {
    String res = "";
    if (diseases.isEmpty) {
      res = "no diseases";
    } else {
      for (int i=0;i<diseases.length;i++) {
        Map<String,dynamic> disease = diseases[i];
        String diseaseText = "${disease["disease"]}";
        if (disease["contagious"]==true) {
          diseaseText = "$res (contagious)";
        } else {
          diseaseText = "$res (not contagious)";
        }
        if (i<diseases.length-1){
          res = "$res$diseaseText | ";
        } else {
          res = res + diseaseText;
        }
      }
    }
    return res;
  }  

  @override
  Widget build(BuildContext context) {




    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        // List<dynamic> petData = settings.petData.value;
        // Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
        Map<String,dynamic> petObject = widget.petData;
        String petName = petObject["name"];
        String petSexSpeciesBreedText = getSexSpeciesBreedText(petObject["sex"],petObject["species"],petObject["breedData"]);
        int petAge = calculateAge(petObject["birthYear"]);
   
        return Card(
          color: Theme.of(context).cardColor,
          child: Column(
            
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: petObject["displayUrl"] != ""
                              ? NetworkImage(petObject["displayUrl"]!) as ImageProvider // keep if you have local file
                              : null,
                
                        ),   
                    ),
                  ),
                  // SizedBox(width: 20,),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              petName,
                              style: Theme.of(context).primaryTextTheme.labelLarge,
                            ),
                          ),
        
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              petSexSpeciesBreedText,
                              style: Theme.of(context).primaryTextTheme.bodySmall,
                            ),
                          ),
        
           
        
                          Divider(color: Theme.of(context).dividerColor,),
        
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.cake,
                                  size: Theme.of(context).primaryTextTheme.bodySmall!.fontSize,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Age: ",
                                  style: Theme.of(context).primaryTextTheme.bodySmall,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$petAge Years Old",
                                  style: Theme.of(context).primaryTextTheme.bodySmall,
                                )
                              )                          
                            ],
                          ),
        
                          Divider(color: Theme.of(context).dividerColor,),                     
        
          
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }
}