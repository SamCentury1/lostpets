import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:tempoct2025/screens/components/map_picker_screen.dart';
import 'package:tempoct2025/screens/pet_screen/pet_screen.dart';
import 'package:tempoct2025/screens/profile_screen/profile_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class EditPetView extends StatefulWidget {
  // final Map<String,dynamic>? petObject;
  final String? petId;
  const EditPetView({
    super.key,
    // required this.petObject
    required this.petId
  });

  @override
  State<EditPetView> createState() => _EditPetViewState();
}

class _EditPetViewState extends State<EditPetView> {
  late TextEditingController petNameController = TextEditingController();
  late TextEditingController petBreedController = TextEditingController();
  late List<String> breedData = [];
  List<Map<String,dynamic>> vaccines = [];
  List<Map<String,dynamic>> diseases = [];

  String species = 'cat';
  String sex = 'male';
  int birthYear = 2015;
  File? petImage;
  String? displayUrl;
  bool allowedOutside = false;
  String? displayLocation;
  Map<String,dynamic> updatePetObject = {};
  List<int> birthYears = List.generate(30, (e) => 2025 - e);

  late SettingsController settings;

  final List<String> speciesOptions = ['cat', 'dog', 'other'];
  final Map<String, List<String>> breedsBySpecies = {
    'cat': ['persian', 'siamese', 'bengal', 'sphynx'],
    'dog': ['labrador', 'poodle', 'beagle', 'bulldog'],
    'other': ['parrot', 'hamster', 'rabbit'],
  };

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(()  {
        petImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Take a photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }




  Future<String?> getLocationText(Map<String,dynamic>? petObject) async {
    String? res = null;
    if (petObject!["location"] != null) {
      final GeoPoint location = petObject!["location"];
      res = await Helpers().getAddressFromGeoPoint(location);
    }
    return res;
  }  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    settings = Provider.of<SettingsController>(context, listen: false);
    late AppState _appState = Provider.of<AppState>(context, listen: false);
    
    if (widget.petId != null) {

      // petNameController = TextEditingController(text: petObject["name"]);
      // species = petObject["species"];
      // petBreedController = TextEditingController(text: petObject["breed"]);
      // breedData = List<String>.from(petObject["breedData"]);
      // sex = petObject["sex"];
      // birthYear = petObject["birthYear"];
      // displayUrl = petObject["displayUrl"];
      // vaccines = List<Map<String,dynamic>>.from(petObject["vaccines"]); // petObject["vaccines"] as List<Map<String,dynamic>>;
      // diseases = List<Map<String,dynamic>>.from(petObject["diseases"]); // petObject["diseases"] as List<Map<String,dynamic>>;
      // allowedOutside = petObject["allowedOutside"];
 
      WidgetsBinding.instance.addPostFrameCallback((_) {

        setState(() {
          Map<String,dynamic> petObject = Helpers().getPetObject(settings, widget.petId!);
          _appState.setNewPetObject(petObject);
          petNameController = TextEditingController(text: petObject["name"]);
          getLocationText(petObject);
          // getLocation(_appState.newPetObject);
        });
        // petNameController = TextEditingController(text: petObject["name"]);
        // species = petObject["species"];
        // petBreedController = TextEditingController(text: petObject["breed"]);
        // breedData = List<String>.from(petObject["breedData"]);
        // sex = petObject["sex"];
        // birthYear = petObject["birthYear"];
        // displayUrl = petObject["displayUrl"];
        // vaccines = List<Map<String,dynamic>>.from(petObject["vaccines"]); // petObject["vaccines"] as List<Map<String,dynamic>>;
        // diseases = List<Map<String,dynamic>>.from(petObject["diseases"]); // petObject["diseases"] as List<Map<String,dynamic>>;
        // allowedOutside = petObject["allowedOutside"];          
      });
      // displayLocation = widg
    } else {
      // updatePetObject = _appState.newPetObject;
    }

  }

  


  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context,appState,child) {

        // // updatePetObject = appState.newPetObject;
        // // getLocation(appState.newPetObject);
        // Map<String,dynamic> petObject = appState.newPetObject; //Helpers().getPetObject(settings, widget.petId!);

        
        species = appState.newPetObject["species"];
        // petBreedController = TextEditingController(text: petObject["breed"]);
        breedData = List<String>.from(appState.newPetObject["breedData"]);
        sex = appState.newPetObject["sex"];
        birthYear = appState.newPetObject["birthYear"];
        displayUrl = appState.newPetObject["displayUrl"];
        vaccines = List<Map<String,dynamic>>.from(appState.newPetObject["vaccines"]); // petObject["vaccines"] as List<Map<String,dynamic>>;
        diseases = List<Map<String,dynamic>>.from(appState.newPetObject["diseases"]); // petObject["diseases"] as List<Map<String,dynamic>>;
        allowedOutside = appState.newPetObject["allowedOutside"];
        

        
        // // if (displayLocation == null) {
        // //   getLocation(petObject);
        // // } else {
        // //   displayLocation = "";
        // // }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
        
              // 🐶 Pet Avatar
              GestureDetector(
                onTap: widget.petId == null ? _showImagePickerOptions : () => _showMediaPicker(appState),
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                            petImage != null ? FileImage(petImage!) : displayUrl != "" ? NetworkImage(displayUrl!) : null,
                        child: petImage == null && displayUrl == null 
                            ? const Icon(Icons.pets, size: 50, color: Colors.grey)
                            : null  ,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
        
        
              // Pet Name
              TextField(
                controller: petNameController,
                decoration: const InputDecoration(
                  labelText: "Pet Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String val) {
                  appState.newPetObject.update("name", (v) => val);
                },
              ),
              const SizedBox(height: 16),
        
              // Species Dropdown
        
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: species,
                      decoration: const InputDecoration(
                        labelText: "Species",
                        border: OutlineInputBorder(),
                      ),
                      items: speciesOptions
                          .map((sp) => DropdownMenuItem(value: sp, child: Text(sp)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          species = value!;
                          appState.newPetObject.update("species", (v)=>value);
                          breedData = [];
                          appState.newPetObject.update("breedData", (v)=>breedData);
                          // petBreedController.clear(); // reset breed when species changes
                        });
                      },
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 16),
        
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                          width: 1.0
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(Helpers().displayBreedDataLabel(breedData)),
                      ),
                    ),
                  ),
        
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(5.0)
                          ),
                          minimumSize: Size(70, 55)
                          
                        ),
                        
                        onPressed: () => _showBreedDialog(context,appState),
                        child: Text(
                          "Add Breed",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          fontSize: 14.0
                        ))
                      ),
                    ),
                  )
                ],
              ),
        
              const SizedBox(height: 16),          
        
              // Birth Year
              DropdownButtonFormField<int>(
                value: birthYear,
                decoration: const InputDecoration(
                  labelText: "Birth Year",
                  border: OutlineInputBorder(),
                ),
                menuMaxHeight: 250,
                items: birthYears
                    .map((year) =>
                        DropdownMenuItem(value: year, child: Text(year.toString())))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    appState.newPetObject.update("birthYear", (v) => value!);
                  });
                },
              ),
              const SizedBox(height: 16),
        
              // Gender
              DropdownButtonFormField<String>(
                value: sex,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                ],
                onChanged: (value) {
                  // setState(() => sex = value!);
                  setState(() {
                    appState.newPetObject.update("sex", (v)=>value!);
                  });
                },
              ),
              const SizedBox(height: 24),
        
              // Gender
              DropdownButtonFormField<bool>(
                value: allowedOutside,
                decoration: const InputDecoration(
                  labelText: "Allowed Outside",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text("Allowed outside")),
                  DropdownMenuItem(value: false, child: Text("Not allowed outside")),
                ],
                onChanged: (value) {
                  // setState(() => allowedOutside = value!);
                  setState(() {
                    appState.newPetObject.update("allowedOutside", (v)=>value!);
                  });                  
                },
              ),
              const SizedBox(height: 16), 
        
        
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                          width: 1.0
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FutureBuilder(
                          future: getLocationText(appState.newPetObject),
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
                                return Text(asyncSnapshot.data.toString());
                              }
                            } else {
                              return Text("");
                            }
                          }
                        ),
                      ),
                    ),
                  ),
        
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(5.0)
                          ),
                          minimumSize: Size(70, 55)
                          
                        ),
                        
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MapPickerScreen(petId: widget.petId,))
                          );                      
                        },
                        child: Text(
                          "Update Location",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          fontSize: 14.0
                        ))
                      ),
                    ),
                  )
                ],
              ),
                    
        
              const SizedBox(height: 24), 
        
              Row(
                children: [
                  Text(
                    "Vaccines",
                    style: Theme.of(context).primaryTextTheme.labelSmall
                  ),
        
                  IconButton(
                    onPressed: ()=>_showVaccineDialog(context,appState),
                    icon: Icon(Icons.add)
                  )                
                ],
              ),
              Column(
                children: vaccines.map((e){
                  
                  return Row(
                    children: [
                      Text("${e["vaccine"]} (${e["year"]})"),
                      IconButton(
                        onPressed: () {
                          int itemIndex = vaccines.indexOf(e);
                          setState(() {
                            vaccines.removeAt(itemIndex);
                            appState.newPetObject.update("vaccines", (v)=>vaccines);
                          });
                        }, 
                        icon: Icon(Icons.remove)
                      )
                    ],
                  );
                }).toList(),
              ),
        
              Row(
                children: [
                  Text(
                    "Diseases",
                    style: Theme.of(context).primaryTextTheme.labelSmall
                  ),
        
                  IconButton(
                    onPressed: () => _showDiseaseDialog(context,appState),
                    icon: Icon(Icons.add)
                  )                
                ],
              ),
        
              Column(
                children: diseases.map((e){
                  String contagiousText = e["contagious"] == true ? "Contagious" : "Not contagious";
                  return Row(
                    children: [
                      Text("${e["disease"]} ($contagiousText)"),
                      IconButton(
                        onPressed: () {
                          int itemIndex = diseases.indexOf(e);
                          setState(() {
                            diseases.removeAt(itemIndex);
                            appState.newPetObject.update("diseases", (v)=>diseases);
                          });
                        }, 
                        icon: Icon(Icons.remove)
                      )
                    ],
                  );
                }).toList(),
              ),            
        
        
        
              // Submit Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _savePet(settings,appState,petImage),
                icon: const Icon(Icons.pets),
                label: const Text("Save Pet"),
              ),
            ],
          ),
        );
      }
    );
  
  }

  void _showBreedDialog(BuildContext context,AppState appState) {
    final breeds = breedsBySpecies[species] ?? [];
    String? selectedBreed1;
    String? selectedBreed2;
    bool isMixed = false;

    showDialog(
      context: context,
      builder: (context,) {
        return StatefulBuilder(
          builder: (context,setStateDialog) {
            return AlertDialog(
              title: Text("Select ${species.toLowerCase()} breed"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            
                  Row(
                    children: [
                      Expanded(child: Text("Mixed Breeds")),
                      Switch(
                        // This bool value toggles the switch.
                        value: isMixed,
                        // activeColor: Colors.red,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setStateDialog(() {
                            isMixed = value;
                          });
                        },
                      ),
                    ],
                  ),
            
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Breed 1",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedBreed1,
                    items: breeds
                        .map((breed) =>
                            DropdownMenuItem(value: breed, child: Text(breed)))
                        .toList(),
                    onChanged: (value) {
                      selectedBreed1 = value;
                    },
                  ),
                  SizedBox(height: 10,),
            
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: isMixed ? "Breed 2" : "None",
                      border: OutlineInputBorder(),
                    ),
                    enableFeedback: isMixed,
                    value: isMixed ? null : selectedBreed2,
                    items: breeds
                        .map((breed) =>
                            DropdownMenuItem(value: breed, child: Text(breed)))
                        .toList(),
                    onChanged: !isMixed ? null : (value) {
                      selectedBreed2 = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedBreed1 != null) {
                        breedData.add(selectedBreed1!);
                      }
                      if (selectedBreed2 != null) {
                        breedData.add(selectedBreed2!);
                      }
                      appState.newPetObject.update("breedData", (v) => breedData);

                      
                      
                    });
                    // if (selectedBreed1 != null) {
                    //   setState(() => petBreedController.text = selectedBreed!);
                    // }
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _savePet(SettingsController settings, AppState appState, File? petImage) {
    // final pet = {
    //   'name': petNameController.text,
    //   'species': species,
    //   'breed': petBreedController.text,
    //   'birthYear': birthYear,
    //   'gender': sex,
    // };
    if (widget.petId == null) {

      //  createPetObject
      FirestoreMethods().createPetObjectInDatabase(settings, appState, petImage);
    } else {
      // appState.newPetObject.update("name",(v) => petNameController.text);
      // appState.newPetObject.update("species",(v) => species);
      // appState.newPetObject.update("breedData",(v) => breedData);
      // appState.newPetObject.update("birthYear",(v) => birthYear);
      // appState.newPetObject.update("displayUrl",(v) => displayUrl);
      // appState.newPetObject.update("vaccines",(v) => vaccines);
      // appState.newPetObject.update("diseases",(v) => diseases);
      // appState.newPetObject.update("allowedOutside",(v) => allowedOutside);    
      FirestoreMethods().updatePetObjectInDatabase(settings, widget.petId!, appState);
    }
    print("Pet saved: ${appState.newPetObject}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pet saved successfully!')),
    );
    appState.setIsEditView(false);
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => const ProfileScreen()),
      ModalRoute.withName('/profile'),
    );    
   

    
  }



  void _showVaccineDialog(BuildContext context,AppState appState) {

    TextEditingController vaccineController = TextEditingController(); 
    int? inoculationYear = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select ${species.toLowerCase()} breed"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Vaxx Name
              TextField(
                controller: vaccineController,
                decoration: const InputDecoration(
                  labelText: "Vaccine",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                value: inoculationYear,
                decoration: const InputDecoration(
                  labelText: "Inocculation Year",
                  border: OutlineInputBorder(),
                ),
                items: birthYears
                    .map((year) =>
                        DropdownMenuItem(value: year, child: Text(year.toString())))
                    .toList(),
                onChanged: (value) {
                  setState(() => inoculationYear = value!);
                },
              ),              
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (inoculationYear != null) {
                  setState(() {
                    vaccines.add({"vaccine": vaccineController.text, "year": inoculationYear!});
                  });
                }

                setState(() {
                  appState.newPetObject.update("vaccines", (v)=>vaccines);
                });                    
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showDiseaseDialog(BuildContext context, AppState appState) {

    TextEditingController diseaseController = TextEditingController(); 
    bool contagious = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select ${species.toLowerCase()} breed"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Vaxx Name
              TextField(
                controller: diseaseController,
                decoration: const InputDecoration(
                  labelText: "Disease",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<bool>(
                value: contagious,
                decoration: const InputDecoration(
                  labelText: "Is Contagious",
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: true, child: Text('Contagious')),
                  DropdownMenuItem(value: false, child: Text('Not contagious')),
                ],
                onChanged: (value) {
                  setState(() => contagious = value!);
                },
              ),              
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (diseaseController.text != "") {
                  setState(() {
                    diseases.add({"disease": diseaseController.text, "contagious": contagious});
                  });
                }
                setState(() {
                  appState.newPetObject.update("diseases", (v)=>diseases);
                });                  
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showMediaPicker(AppState appState) {
    // List<dynamic> petData = settings.petData.value;
    // Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});    
    // final mediaList = petObject["media"] as List<dynamic>;
    // if (mediaList.isEmpty) return;
    List<dynamic> media = appState.newPetObject["media"];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: media.length,
            itemBuilder: (context, index) {
              final url = media[index];
              return GestureDetector(
                onTap: () {
                  // set the tapped image as the avatar
                  setState(() {
                    petImage = null; // clear local file
                    appState.newPetObject.update("displayUrl", (v)=>url);
                    // petObject["displayUrl"] = url; // optional
                    // selectedDisplayImageUrl = url;

                    // FirestoreMethods().updatePetDisplayUrl(settings,widget.petId,url);

                    // print("selected: ${petObject["displayImage"]}");
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, _) =>
                          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, _, __) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }   
}


