import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/authentication/auth_screen.dart';
import 'package:tempoct2025/screens/components/map_picker_screen.dart';
import 'package:tempoct2025/screens/home_screen/home_screen.dart';
import 'package:tempoct2025/settings/settings.dart';


class NewPostingScreen extends StatefulWidget {
  final String petId;
  const NewPostingScreen({
    super.key,
    required this.petId
  });

  @override
  State<NewPostingScreen> createState() => _NewPostingScreenState();
}

class _NewPostingScreenState extends State<NewPostingScreen> {

  
  DateTime? selectedDate;
  String selectedDateString = "";
  DateTime today = DateTime.now();
  DateTime? firstDate;
  DateTime? lastDate;
  DateTime? initialDate;

  late bool warningsAcknowledged = false;

  late TextEditingController _descriptionController;
  late SettingsController _settings;
  String locationText = "Update Location";

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialDate = DateTime(today.year,today.month,today.day);
    selectedDate = initialDate;
    selectedDateString = DateFormat.yMMMd().format(selectedDate!);
    firstDate = DateTime(2000);
    lastDate = DateTime(today.year);
    _descriptionController = TextEditingController();
    _settings = Provider.of<SettingsController>(context, listen: false);
    
  }
  

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate!,
      lastDate: initialDate!,
    );

    setState(() {
      selectedDate = pickedDate;
      selectedDateString = DateFormat.yMMMd().format(selectedDate!);
    });
  }  


  Future<String?> getLocationText(Map<String,dynamic>? postingObject) async {
    String? res = null;
    if (postingObject!["location"] != null) {
      final GeoPoint location = postingObject!["location"];
      res = await Helpers().getPostalCodeFromGeoPoint(location);
    } else {
      res = "Select Location";
    }
    return res;
  } 


  Future<void> updateLocation(AppState appState, LatLng? selectedPosition) async {
    // if (widget.petId!=null) {
    try {
      if (selectedPosition!=null) {
        final newLocation = GeoPoint(selectedPosition.latitude, selectedPosition.longitude);
        appState.newPostingData.update("location", (v)=> newLocation);
        appState.setNewPostingData(appState.newPostingData);
      }
    } catch (e,s) {
      debugPrint("error: $e | stacktrace: $s");
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Map<String,dynamic> userData = _settings.userData.value as Map<String,dynamic>;
    Map<String,dynamic> petObject = Helpers().getPetObject(_settings,widget.petId);
    List<dynamic> media = petObject["media"];

    return Consumer<AppState>(
      builder: (context,appState,child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("New Posting"),
            leading: IconButton(
              onPressed: () {
                appState.setNewPostingData({});
                Navigator.of(context).pop();
              }, 
              icon: Icon(Icons.arrow_back)
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                      
                  // Date controller
                  const SizedBox(height: 30,),
              
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create a posting to alert all nearby users.",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                
                  const SizedBox(height: 16),
                  SizedBox(height: 16,),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                          width: 1.0
                        )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                selectedDate != null
                                    ? 'Missing since: ${selectedDateString}'
                                    : 'Missing Since',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(Icons.calendar_month),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16,),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MapPickerScreen(petId: widget.petId, onPressed: updateLocation,))
                      );                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                          width: 1.0
                        )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder(
                                future: getLocationText(appState.newPostingData),
                                builder: (context, asyncSnapshot) {
                                  if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                    return Text("Loading Address...");
                                  } else if (asyncSnapshot.hasError) {
                                    debugPrint("error: ${asyncSnapshot.error} | stacktrace: ${asyncSnapshot.stackTrace}");
                                    return Text("Error getting location");
                                  } else if (asyncSnapshot.hasData) {
                                    if (asyncSnapshot.data==null) {
                                      return Text("Choose Location");
                                    } else {
                                      return Text("Lost in: ${asyncSnapshot.data.toString()}");
                                    }
                                  } else {
                                    return Text("");
                                  }
                                }
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(Icons.edit_location),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),                  
              
                  SizedBox(height: 30,),


                  Row(
                    children: [
                      Text(
                        "Media",
                        style: Theme.of(context).primaryTextTheme.bodyMedium
                      ),
                      SizedBox(width: 30,),
                      IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.add_photo_alternate_outlined),
                      )
                      
                    ],
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: media.map((e) {
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: Image(
                            image: NetworkImage(e),
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 16,),

                  
              
                  TextField(
                    maxLines: 4,
                    controller: _descriptionController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16.0 ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: const Color.fromARGB(101, 0, 0, 0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: const Color.fromARGB(75, 0, 0, 0)),
                      ),
                      // focusColor: palette.inputFieldTextColor,
                      // fillColor: palette.inputFieldBgColor,
                      filled: true,
                      hintText: "Description",
                      hintStyle: TextStyle(
                        // color: palette.text1,
                        fontSize: 18,
                      )
                    ),
                  ),

                  SizedBox(height: 30,),


                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: ()  {

                      List<Map<String,dynamic>> errors = [];
                      if (_descriptionController.text == "") {
                        errors.add({"type":"error","body":"Make sure to add a description to the post"});
                      }
                      if (media.length < 5) {
                        errors.add({"type":"warning","body":"Your pet profile has less than 5 photos, it's recommended to have at least 10."});
                      }
                      if (petObject["questionnaire"].isEmpty) {
                        errors.add({"type":"warning", "body":"Your pet profile does not contain a questionnaire to help identify your pet's unique characteristics"});
                      }
                      if (selectedDate==null) {
                        errors.add({"type":"error", "body":"Missing since date missing"});
                      }
                      if (appState.newPostingData["location"]==null) {
                        errors.add({"type":"error", "body":"No pet location was selected"});
                      }
                      if (errors.isEmpty || warningsAcknowledged) {
                        _openReviewDialog(appState);
                      } else {
                        _openErrorDialog(appState, errors);
                      }
                    },
                    icon: const Icon(Icons.post_add_outlined),
                    label:Text("Review"),
                  ),                  
        
        

                ],
              ),
            ),
          ),
        );
      }
    );
  }


  void _openReviewDialog(AppState appState) {

    Map<String,dynamic> petObject = Helpers().getPetObject(_settings,widget.petId);
    List<dynamic> media = petObject["media"];
    dynamic displayUrl = petObject["displayUrl"];
    List<dynamic> questionnaire = petObject["questionnaire"];

    String dateString = (DateFormat.yMMMd().format(selectedDate!));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // insetPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          title: Text("Review"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Image(
                      image: NetworkImage(displayUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(174, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            petObject["name"],
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                        ),
                      ),
                    )
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.calendar_month)
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("Last seen: ")
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("$dateString")
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.location_on)
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("Lost around: ")
                  ),                  
                  Expanded(
                    flex: 3,
                    child: FutureBuilder(
                      future: getLocationText(appState.newPostingData),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading Address...");
                        } else if (asyncSnapshot.hasError) {
                          debugPrint("error: ${asyncSnapshot.error} | stacktrace: ${asyncSnapshot.stackTrace}");
                          return Text("Error getting location");
                        } else if (asyncSnapshot.hasData) {
                          if (asyncSnapshot.data==null) {
                            return Text("Choose Location");
                          } else {
                            return Text("${asyncSnapshot.data.toString()}");
                          }
                        } else {
                          return Text("");
                        }
                      }
                    ),
                  )
                  
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                  
                  appState.newPostingData.update("name", petObject["name"]);
                  appState.newPostingData.update("description", (v) => _descriptionController.text);
                  appState.newPostingData.update("missingSince", (v) => selectedDate);
                  appState.newPostingData.update("createdAt", (v) => DateTime.now().toIso8601String(),);




       
                  await FirestoreMethods().createPosting(appState).then((_) {
                    debugPrint("posting created successfully!");
                    appState.setNewPostingData({});
                    if (!mounted) return;
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(builder: (BuildContext context) => const AuthScreen()),
                      ModalRoute.withName('/home'),
                    );                      
                  }).catchError((e) {
                    debugPrint("Error creating posting: $e");
                  });

                


              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );    
  }


  void _openErrorDialog(AppState appState, List<Map<String,dynamic>> errors) {

    int errorCount = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // insetPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          title: Text("Hold on"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: errors.map((e) {
              if (e["type"]=="error") {
                errorCount++;
              }
              return Row(
                children: [
                  e["type"]=="error" ? Icon(Icons.error) : Icon(Icons.warning),
                  SizedBox(width: 10,),
                  Flexible(child: Text(e["body"]))
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (errorCount==0) {
                  setState(() {
                    warningsAcknowledged = true;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            ),
          ],
        );
      },
    );    
  }  
}