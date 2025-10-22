import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tempoct2025/screens/components/edit_pet_view.dart';

class NewPetScreen extends StatefulWidget {
  const NewPetScreen({super.key});

  @override
  State<NewPetScreen> createState() => _NewPetScreenState();
}

class _NewPetScreenState extends State<NewPetScreen> {
  // final TextEditingController petNameController = TextEditingController();
  // final TextEditingController petBreedController = TextEditingController();
  // List<Map<String,dynamic>> vaccines = [];
  // List<Map<String,dynamic>> diseases = [];

  // String species = 'Cat';
  // String sex = 'Male';
  // int birthYear = 2015;
  // File? petImage;

  // List<int> birthYears = List.generate(30, (e) => 2025 - e);

  // final List<String> speciesOptions = ['Cat', 'Dog', 'Other'];
  // final Map<String, List<String>> breedsBySpecies = {
  //   'Cat': ['Persian', 'Siamese', 'Bengal', 'Sphynx'],
  //   'Dog': ['Labrador', 'Poodle', 'Beagle', 'Bulldog'],
  //   'Other': ['Parrot', 'Hamster', 'Rabbit'],
  // };

  // final ImagePicker _picker = ImagePicker();

  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
  //   if (pickedFile != null) {
  //     setState(() => petImage = File(pickedFile.path));
  //   }
  // }

  // void _showImagePickerOptions() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (_) => SafeArea(
  //       child: Wrap(
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.photo_camera),
  //             title: const Text("Take a photo"),
  //             onTap: () {
  //               Navigator.pop(context);
  //               _pickImage(ImageSource.camera);
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.photo_library),
  //             title: const Text("Choose from gallery"),
  //             onTap: () {
  //               Navigator.pop(context);
  //               _pickImage(ImageSource.gallery);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Pet")),
      body: EditPetView(petId: null),
      // body: SingleChildScrollView(
      //   padding: const EdgeInsets.all(20),
      //   child: Column(
      //     children: [

      //       // 🐶 Pet Avatar
      //       GestureDetector(
      //         onTap: _showImagePickerOptions,
      //         child: Center(
      //           child: Stack(
      //             children: [
      //               CircleAvatar(
      //                 radius: 60,
      //                 backgroundColor: Colors.grey.shade200,
      //                 backgroundImage:
      //                     petImage != null ? FileImage(petImage!) : null,
      //                 child: petImage == null
      //                     ? const Icon(Icons.pets, size: 50, color: Colors.grey)
      //                     : null,
      //               ),
      //               Positioned(
      //                 bottom: 0,
      //                 right: 4,
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     color: Theme.of(context).colorScheme.primary,
      //                     shape: BoxShape.circle,
      //                   ),
      //                   padding: const EdgeInsets.all(6),
      //                   child: const Icon(
      //                     Icons.camera_alt,
      //                     color: Colors.white,
      //                     size: 20,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 24),


      //       // Pet Name
      //       TextField(
      //         controller: petNameController,
      //         decoration: const InputDecoration(
      //           labelText: "Pet Name",
      //           border: OutlineInputBorder(),
      //         ),
      //       ),
      //       const SizedBox(height: 16),

      //       // Species Dropdown

      //       Row(
      //         children: [
      //           Expanded(
      //             flex: 2,
      //             child: DropdownButtonFormField<String>(
      //               value: species,
      //               decoration: const InputDecoration(
      //                 labelText: "Species",
      //                 border: OutlineInputBorder(),
      //               ),
      //               items: speciesOptions
      //                   .map((sp) => DropdownMenuItem(value: sp, child: Text(sp)))
      //                   .toList(),
      //               onChanged: (value) {
      //                 setState(() {
      //                   species = value!;
      //                   petBreedController.clear(); // reset breed when species changes
      //                 });
      //               },
      //             ),
      //           ),

      //           Expanded(
      //             flex: 1,
      //             child: Padding(
      //               padding: const EdgeInsets.all(2.0),
      //               child: ElevatedButton(
                      
      //                 style: ElevatedButton.styleFrom(
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadiusGeometry.circular(5.0)
      //                   )  
      //                 ),
      //                 onPressed: () => _showBreedDialog(context),
      //                 child: Text(
      //                   "Add Breed",
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                   fontSize: 14.0
      //                 ))
      //               ),
      //             ),
      //           )
      //         ],
      //       ),

      //       const SizedBox(height: 16),

      //       // Birth Year
      //       DropdownButtonFormField<int>(
      //         value: birthYear,
      //         decoration: const InputDecoration(
      //           labelText: "Birth Year",
      //           border: OutlineInputBorder(),
      //         ),
      //         menuMaxHeight: 250,
      //         items: birthYears
      //             .map((year) =>
      //                 DropdownMenuItem(value: year, child: Text(year.toString())))
      //             .toList(),
      //         onChanged: (value) {
      //           setState(() => birthYear = value!);
      //         },
      //       ),
      //       const SizedBox(height: 16),

      //       // Gender
      //       DropdownButtonFormField<String>(
      //         value: sex,
      //         decoration: const InputDecoration(
      //           labelText: "Gender",
      //           border: OutlineInputBorder(),
      //         ),
      //         items: const [
      //           DropdownMenuItem(value: "Male", child: Text("Male")),
      //           DropdownMenuItem(value: "Female", child: Text("Female")),
      //         ],
      //         onChanged: (value) {
      //           setState(() => sex = value!);
      //         },
      //       ),
      //       const SizedBox(height: 24),

      //       Row(
      //         children: [
      //           Text(
      //             "Vaccines",
      //             style: Theme.of(context).primaryTextTheme.labelSmall
      //           ),

      //           IconButton(
      //             onPressed: ()=>_showVaccineDialog(context),
      //             icon: Icon(Icons.add)
      //           )                
      //         ],
      //       ),
      //       Column(
      //         children: vaccines.map((e){
                
      //           return Row(
      //             children: [
      //               Text("${e["vaccine"]} (${e["year"]})"),
      //               IconButton(
      //                 onPressed: () {
      //                   int itemIndex = vaccines.indexOf(e);
      //                   setState(() {
      //                     vaccines.removeAt(itemIndex);
      //                   });
      //                 }, 
      //                 icon: Icon(Icons.remove)
      //               )
      //             ],
      //           );
      //         }).toList(),
      //       ),

      //       Row(
      //         children: [
      //           Text(
      //             "Diseases",
      //             style: Theme.of(context).primaryTextTheme.labelSmall
      //           ),

      //           IconButton(
      //             onPressed: () => _showDiseaseDialog(context),
      //             icon: Icon(Icons.add)
      //           )                
      //         ],
      //       ),

      //       Column(
      //         children: diseases.map((e){
      //           String contagiousText = e["contagious"] == true ? "Contagious" : "Not contagious";
      //           return Row(
      //             children: [
      //               Text("${e["disease"]} ($contagiousText"),
      //               IconButton(
      //                 onPressed: () {
      //                   int itemIndex = diseases.indexOf(e);
      //                   setState(() {
      //                     diseases.removeAt(itemIndex);
      //                   });
      //                 }, 
      //                 icon: Icon(Icons.remove)
      //               )
      //             ],
      //           );
      //         }).toList(),
      //       ),            



      //       // Submit Button
      //       ElevatedButton.icon(
      //         style: ElevatedButton.styleFrom(
      //           minimumSize: const Size.fromHeight(50),
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(12)),
      //         ),
      //         onPressed: _savePet,
      //         icon: const Icon(Icons.pets),
      //         label: const Text("Save Pet"),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // void _showBreedDialog(BuildContext context) {
  //   final breeds = breedsBySpecies[species] ?? [];
  //   String? selectedBreed;

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Select ${species.toLowerCase()} breed"),
  //         content: DropdownButtonFormField<String>(
  //           decoration: const InputDecoration(
  //             labelText: "Breed",
  //             border: OutlineInputBorder(),
  //           ),
  //           value: selectedBreed,
  //           items: breeds
  //               .map((breed) =>
  //                   DropdownMenuItem(value: breed, child: Text(breed)))
  //               .toList(),
  //           onChanged: (value) {
  //             selectedBreed = value;
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (selectedBreed != null) {
  //                 setState(() => petBreedController.text = selectedBreed!);
  //               }
  //               Navigator.pop(context);
  //             },
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _savePet() {
  //   final pet = {
  //     'name': petNameController.text,
  //     'species': species,
  //     'breed': petBreedController.text,
  //     'birthYear': birthYear,
  //     'gender': sex,
  //   };
  //   print("Pet saved: $pet");
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Pet saved successfully!')),
  //   );
  // }



  // void _showVaccineDialog(BuildContext context) {

  //   TextEditingController vaccineController = TextEditingController(); 
  //   int? inoculationYear = null;

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Select ${species.toLowerCase()} breed"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Vaxx Name
  //             TextField(
  //               controller: vaccineController,
  //               decoration: const InputDecoration(
  //                 labelText: "Vaccine",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),

  //             DropdownButtonFormField<int>(
  //               value: inoculationYear,
  //               decoration: const InputDecoration(
  //                 labelText: "Inocculation Year",
  //                 border: OutlineInputBorder(),
  //               ),
  //               items: birthYears
  //                   .map((year) =>
  //                       DropdownMenuItem(value: year, child: Text(year.toString())))
  //                   .toList(),
  //               onChanged: (value) {
  //                 setState(() => inoculationYear = value!);
  //               },
  //             ),              
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (inoculationYear != null) {
  //                 setState(() {
  //                   vaccines.add({"vaccine": vaccineController.text, "year": inoculationYear!});
  //                 });
  //               }
  //               Navigator.pop(context);
  //             },
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showDiseaseDialog(BuildContext context) {

  //   TextEditingController diseaseController = TextEditingController(); 
  //   bool contagious = false;

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Select ${species.toLowerCase()} breed"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Vaxx Name
  //             TextField(
  //               controller: diseaseController,
  //               decoration: const InputDecoration(
  //                 labelText: "Disease",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),

  //             DropdownButtonFormField<bool>(
  //               value: contagious,
  //               decoration: const InputDecoration(
  //                 labelText: "Is Contagious",
  //                 border: OutlineInputBorder(),
  //               ),
  //               items: [
  //                 DropdownMenuItem(value: true, child: Text('Contagious')),
  //                 DropdownMenuItem(value: false, child: Text('Not contagious')),
  //               ],
  //               onChanged: (value) {
  //                 setState(() => contagious = value!);
  //               },
  //             ),              
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (diseaseController.text != "") {
  //                 setState(() {
  //                   diseases.add({"disease": diseaseController.text, "contagious": contagious});
  //                 });
  //               }
  //               Navigator.pop(context);
  //             },
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }  
}


