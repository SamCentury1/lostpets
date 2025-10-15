import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/functions/widgets.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/components/multi_image_picker.dart';
import 'package:tempoct2025/screens/components/pet_map.dart';
import 'package:tempoct2025/settings/settings.dart';

class OverviewView extends StatefulWidget {
  final String petId;
  const OverviewView({
    super.key,
    required this.petId
  });

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {



  final ImagePicker _picker = ImagePicker();
  File? petImage;
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => petImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        List<dynamic> petData = settings.petData.value;
        Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Column(
                children: [
              
                    SizedBox(height: 40,),
                    // 🐶 Pet Avatar
                    Center(
                      child: GestureDetector(
                        onTap: () => _showMediaPicker(settings),
                        child: Center(
                          child: Stack(
                            children: [
                        
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: petObject["displayUrl"] != ""
                                    ? NetworkImage(petObject["displayUrl"]!) as ImageProvider // keep if you have local file
                                    : null,
                                child: (petImage == null && petObject["media"].isEmpty)
                                    ? const Icon(Icons.pets, size: 50, color: Colors.grey)
                                    : null,
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
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Widgets().petProfileAttributeRow("Name: ", petObject["name"],),
                              Divider(),
                              Widgets().petProfileAttributeRow("Species: ", petObject["species"],),
                              Divider(),
                              Widgets().petProfileAttributeRow("Breed: ", petObject["breed"],),
                              Divider(),
                              Widgets().petProfileAttributeRow("Sex: ", petObject["sex"],),
                              Divider(),
                              Widgets().petProfileAttributeRow("Age: ", "${Helpers().calculateAge(petObject["birthYear"]).toString()} years old",),
                              Divider(),
                              Widgets().vaccinesWidget(context, petObject["vaccines"]),
                              Divider(),
                              Widgets().diseasesWidget(context, petObject["diseases"]),                            
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => PetMapScreen(petObject: petObject,))
                          );                      
                        }, 
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.all(Radius.circular(12.0))
                          )
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,size: 22.0,),
                            SizedBox(width: 20.0,),
                            Text(
                              "View on Map",
                              style: TextStyle(
                                fontSize: 22.0
                              )
                            ),
                          ],
                        )
                      ),
                    )

              

                    // Text(
                    //   "Vaccines",
                    //   style: Theme.of(context).primaryTextTheme.bodyLarge,
                    // ),     
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 12.0),
                    //   child: Widgets().vaccinesWidget(context, petObject["vaccines"]),
                    // ),


                                        

                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) => PetMapScreen(),)
                    //     );                    
                    //   }, 
                    //   child: Text("Map"),
                    // ),
                      
                       
              
                    // Text(
                    //   "Images: ",
                    //   style: Theme.of(context).primaryTextTheme.labelMedium,
                    // ),
                            
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: petObject["media"].map<Widget>((url) {
                    //       return Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: CachedNetworkImage(
                    //           imageUrl: url,
                    //           height: 80,
                    //           width: 80,
                    //           fit: BoxFit.cover,
                    //           placeholder: (context, _) => const Center(
                    //             child: CircularProgressIndicator(strokeWidth: 2),
                    //           ),
                    //           errorWidget: (context, _, __) =>
                    //               const Icon(Icons.broken_image, size: 50),
                    //         ),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                    // Divider(),            
              
                    // Text(
                    //   "Upload Image: ",
                    //   style: Theme.of(context).primaryTextTheme.labelMedium,
                    // ),
              
              
              
                    // SizedBox(height: 40,),
              
                    // MultiImageUploader(
                    //   petId: widget.petId, // e.g. FirebaseAuth.instance.currentUser!.uid
                    //   onUploadComplete: (urls) {
                    //     print("Uploaded images:");
                    //     for (final url in urls) {
                    //       print(url);
                    //     }
                    //   },
                    // ),
                      
                ],        
              ),
          ),
        );
      }
    );

    
  }

  

  void _showMediaPicker(SettingsController settings) {
    List<dynamic> petData = settings.petData.value;
    Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});    
    final mediaList = petObject["media"] as List<dynamic>;
    if (mediaList.isEmpty) return;

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
            itemCount: mediaList.length,
            itemBuilder: (context, index) {
              final url = mediaList[index];
              return GestureDetector(
                onTap: () {
                  // set the tapped image as the avatar
                  setState(() {
                    petImage = null; // clear local file
                    petObject["displayUrl"] = url; // optional
                    // selectedDisplayImageUrl = url;

                    FirestoreMethods().updatePetDisplayUrl(settings,widget.petId,url);

                    print("selected: ${petObject["displayImage"]}");
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