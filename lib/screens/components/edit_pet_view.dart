import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tempoct2025/functions/helpers.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:tempoct2025/screens/components/map_picker_screen.dart';

class EditPetView extends StatefulWidget {
  final Map<String,dynamic>? petObject;
  const EditPetView({
    super.key,
    required this.petObject
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

  List<int> birthYears = List.generate(30, (e) => 2025 - e);

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
      setState(() => petImage = File(pickedFile.path));
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




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.petObject != null) {
      petNameController = TextEditingController(text: widget.petObject!["name"]);
      species = widget.petObject!["species"];
      petBreedController = TextEditingController(text: widget.petObject!["breed"]);
      breedData = List<String>.from(widget.petObject!["breedData"]);
      sex = widget.petObject!["sex"];
      birthYear = widget.petObject!["birthYear"];
      displayUrl = widget.petObject!["displayUrl"];
      vaccines = List<Map<String,dynamic>>.from(widget.petObject!["vaccines"]); // widget.petObject!["vaccines"] as List<Map<String,dynamic>>;
      diseases = List<Map<String,dynamic>>.from(widget.petObject!["diseases"]); // widget.petObject!["diseases"] as List<Map<String,dynamic>>;
      allowedOutside = widget.petObject!["allowedOutside"];
    }

  }

  


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          // 🐶 Pet Avatar
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        petImage != null ? FileImage(petImage!) : displayUrl != null ? NetworkImage(displayUrl!) : null,
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
                      breedData = [];
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
                // child: TextField(
                //   // controller: petBreedController,
                  
                //   enabled: false,
                //   decoration: const InputDecoration(
                //     labelText: "Breed",
                //     border: OutlineInputBorder(),
                //   ),
                // ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(5.0)
                      )  
                    ),
                    onPressed: () => _showBreedDialog(context),
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
              setState(() => birthYear = value!);
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
              setState(() => sex = value!);
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
              setState(() => allowedOutside = value!);
            },
          ),
          const SizedBox(height: 24), 

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MapPickerScreen())
              );
            },
            child: Text("Enter Address"),
          ),                   

          const SizedBox(height: 24), 

          Row(
            children: [
              Text(
                "Vaccines",
                style: Theme.of(context).primaryTextTheme.labelSmall
              ),

              IconButton(
                onPressed: ()=>_showVaccineDialog(context),
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
                onPressed: () => _showDiseaseDialog(context),
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
            onPressed: _savePet,
            icon: const Icon(Icons.pets),
            label: const Text("Save Pet"),
          ),
        ],
      ),
    );
  
  }

  void _showBreedDialog(BuildContext context) {
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

  void _savePet() {
    final pet = {
      'name': petNameController.text,
      'species': species,
      'breed': petBreedController.text,
      'birthYear': birthYear,
      'gender': sex,
    };
    print("Pet saved: $pet");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pet saved successfully!')),
    );
  }



  void _showVaccineDialog(BuildContext context) {

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
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showDiseaseDialog(BuildContext context) {

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
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }  
}


