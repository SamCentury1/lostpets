import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/widgets.dart';
import 'package:tempoct2025/screens/pet_screen/pet_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class PetCardWidget extends StatefulWidget {
  // final Map<String,dynamic> petData;
  final String petId;
  const PetCardWidget({
    super.key,
    required this.petId
    // required this.petData
  });

  @override
  State<PetCardWidget> createState() => _PetCardWidgetState();
}

class _PetCardWidgetState extends State<PetCardWidget> {


  int calculateAge(int birthYear) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int age = currentYear-birthYear;
    return age;
  }

  String getSexSpeciesBreedText(String sex, String species, String breed) {
    String res = "";
    if (breed=="unknown") {
      res = "$sex $species - unknown breed";
    } else {
      res = "$sex $species $breed";
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

        List<dynamic> petData = settings.petData.value;
        Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
        String petName = petObject["name"];
        String petSexSpeciesBreedText = getSexSpeciesBreedText(petObject["sex"],petObject["species"],petObject["breed"]);
        String petSex = petObject["sex"];
        int petAge = calculateAge(petObject["birthYear"]);
        String vaccines = getVaccinesText(petObject["vaccines"]);
        String diseases = getDiseasesText(petObject["diseases"]);        
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PetScreen(petId: petObject["uid"],))
            );        
          },
          child: Card(
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
          
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       flex: 1,
                            //       child: Icon(
                            //         Icons.vaccines,
                            //         size: Theme.of(context).primaryTextTheme.bodySmall!.fontSize,
                            //       ),
                            //     ),                          
                            //     Expanded(
                            //       flex: 2,
                            //       child: Text(
                            //         "Vaccines: ",
                            //         style: Theme.of(context).primaryTextTheme.bodySmall,
                            //       ),
                            //     ),
                            //     Expanded(
                            //       flex: 3,
                            //       child: Text(
                            //         vaccines,
                            //         style: Theme.of(context).primaryTextTheme.bodySmall,
                            //       ),
                            //     )                          
                            //   ],
                            // ),
                            // Widgets().vaccinesWidget(context, petObject["vaccines"]),
                            // Divider(color: Theme.of(context).dividerColor,),
                            // Widgets().diseasesWidget(context, petObject["diseases"])
                            // Row(
                            //   children: [
          
                            //     Expanded(
                            //       flex: 1,
                            //       child: Icon(
                            //         Icons.local_hospital,
                            //         size: Theme.of(context).primaryTextTheme.bodySmall!.fontSize,
                            //       ),
                            //     ),                          
                            //     Expanded(
                            //       flex: 2,
                            //       child: Text(
                            //         "Diseases: ",
                            //         style: Theme.of(context).primaryTextTheme.bodySmall,
                            //       ),
                            //     ),
                            //     Expanded(
                            //       flex: 3,
                            //       child: Text(
                            //         diseases,
                            //         style: Theme.of(context).primaryTextTheme.bodySmall,
                            //       ),
                            //     )                          
                            //   ],
                            // )                      
          
          
          
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}



// Widget vaccinesWidget(BuildContext context, List<dynamic> vaccines,) {

//   String label = "Vaccines: ";
//   if (vaccines.isEmpty) {
//     label = "${label}none";
//   }
//   return Column(
//     children: [
//       Align(
//         alignment: Alignment.centerLeft, 
//         child: Text(label)),
//       Column(
//         children: vaccines.map((e) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Row(
//               children: [
//                 Icon(Icons.vaccines,size: Theme.of(context).primaryTextTheme.bodySmall!.fontSize),
//                 Text("${e["name"]} (${e["year"]})")
//               ],
//             ),
//           );
//         }).toList(),
//       )
//     ],
//   );
// } 
// Widget diseasesWidget(BuildContext context, List<dynamic> diseases,) {

//   String label = "Diseases: ";
//   if (diseases.isEmpty) {
//     label = "${label}none";
//   }

//   print("disesases: $diseases");

//   return Column(
//     children: [
//       Align(
//         alignment: Alignment.centerLeft, 
//         child: Text(label)),
//       Column(
//         children: diseases.map((e) {
//           String contagious = "contagious";
//           if (!e["contagious"]) {
//             contagious = "not contagious";
//           }
//           return Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Row(
//               children: [
//                 Icon(Icons.local_hospital,size: Theme.of(context).primaryTextTheme.bodySmall!.fontSize),
//                 Text("${e["name"]} ($contagious)")
//               ],
//             ),
//           );
//         }).toList(),
//       )
//     ],
//   );
// } 
