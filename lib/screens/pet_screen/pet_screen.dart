import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/components/multi_image_picker.dart';
import 'package:tempoct2025/screens/components/pet_map.dart';
import 'package:tempoct2025/screens/pet_screen/views/media/media_view.dart';
import 'package:tempoct2025/screens/pet_screen/views/overview/overview_view.dart';
import 'package:tempoct2025/screens/pet_screen/views/questionnaire/questionnaire_view.dart';
import 'package:tempoct2025/settings/settings.dart';

class PetScreen extends StatefulWidget {
  final String petId;
  const PetScreen({
    super.key,
    required this.petId
  });

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {

  late SettingsController _settings;
  File? petDisplayImage;
  late String? selectedDisplayImageUrl = null;
  late int _selectedIndex = 0;
  late List<Widget> _widgetOptions = [];
  
  // late Map<String,dynamic> petObject = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController();
    _settings = Provider.of<SettingsController>(context, listen: false);
    List<dynamic> petData = _settings.petData.value;    
    Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
    

    List<Widget> images = petObject["media"].map<Widget>((url) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          imageUrl: url,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
          placeholder: (context, _) => const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, _, __) =>
              const Icon(Icons.broken_image, size: 50),
        ),
      );
    }).toList() ;

    _widgetOptions = [
      OverviewView(petId: widget.petId),
      MediaView(petId: widget.petId, images: images,),
      QuestionnaireView(petId: widget.petId,),
      // PetMapScreen(petObject: petObject,)
    ];
    // settings = Provider.of<SettingsController>(context, listen: false);
    // List<dynamic> petData = settings.petData.value;
    // setState(() {
    //   petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
    // });

    // print("displayUrl: ${petObject["displayUrl"]}");
    
  }

  late PageController controller;



  void _onItemTapped(int index) {

    setState(() {
      controller.animateToPage(
        index,
        duration: Duration(milliseconds: 300), // or any duration you prefer
        curve: Curves.decelerate
      );
    });
    // print("animate to index: ${index} " );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }  



  // final ImagePicker _picker = ImagePicker();
  File? petImage;
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
    return Consumer<SettingsController>(
      builder: (context,settings,child) {
        List<dynamic> petData = settings.petData.value;
        Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
        

        return Scaffold(
          appBar: AppBar(
            title: Text("Pet Profile"),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // body: SingleChildScrollView(
          //   child: Column(
          //     children: [

          //         SizedBox(height: 40,),
          //         // 🐶 Pet Avatar
          //         Center(
          //           child: GestureDetector(
          //             onTap: () => _showMediaPicker(settings),
          //             child: Center(
          //               child: Stack(
          //                 children: [
          
          //                   CircleAvatar(
          //                     radius: 60,
          //                     backgroundColor: Colors.grey.shade200,
          //                     backgroundImage: petObject["displayUrl"] != ""
          //                         ? NetworkImage(petObject["displayUrl"]!) as ImageProvider // keep if you have local file
          //                         : null,
          //                     child: (petImage == null && petObject["media"].isEmpty)
          //                         ? const Icon(Icons.pets, size: 50, color: Colors.grey)
          //                         : null,
          //                   ),                      
          //                   Positioned(
          //                     bottom: 0,
          //                     right: 4,
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         color: Theme.of(context).colorScheme.primary,
          //                         shape: BoxShape.circle,
          //                       ),
          //                       padding: const EdgeInsets.all(6),
          //                       child: const Icon(
          //                         Icons.camera_alt,
          //                         color: Colors.white,
          //                         size: 20,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(height: 24), 
          //         Divider(),
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 flex: 2,
          //                 child: Text(
          //                   "Name: ",
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 4,
          //                 child: Text(
          //                   petObject["name"],
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(),

          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 flex: 2,
          //                 child: Text(
          //                   "Species: ",
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 4,
          //                 child: Text(
          //                   petObject["species"],
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(),  

          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 flex: 2,
          //                 child: Text(
          //                   "Breed: ",
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 4,
          //                 child: Text(
          //                   petObject["breed"],
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(),                                    
        
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 flex: 2,
          //                 child: Text(
          //                   "Sex: ",
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 4,
          //                 child: Text(
          //                   petObject["sex"],
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(),    

          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 flex: 2,
          //                 child: Text(
          //                   "Age: ",
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 4,
          //                 child: Text(
          //                   "${Helpers().calculateAge(petObject["birthYear"]).toString()} years old",
          //                   style: Theme.of(context).primaryTextTheme.bodySmall,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(),

          //         // Column(
          //         //   children: petObject["vaccines"].map((e){
                      
          //         //     return Row(
          //         //       children: <Widget>[
          //         //         Text("${e["vaccine"]} (${e["year"]})"),
          //         //       ],
          //         //     );
          //         //   }).toList(),
          //         // ),                                           
        
          //         ElevatedButton(
          //           onPressed: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(builder: (context) => PetMapScreen(),)
          //             );                    
          //           }, 
          //           child: Text("Map"),
          //         ),
        
         
            
          //         Text(
          //           "Images: ",
          //           style: Theme.of(context).primaryTextTheme.labelMedium,
          //         ),
                          
          //         SingleChildScrollView(
          //           scrollDirection: Axis.horizontal,
          //           child: Row(
          //             children: petObject["media"].map<Widget>((url) {
          //               return Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: CachedNetworkImage(
          //                   imageUrl: url,
          //                   height: 80,
          //                   width: 80,
          //                   fit: BoxFit.cover,
          //                   placeholder: (context, _) => const Center(
          //                     child: CircularProgressIndicator(strokeWidth: 2),
          //                   ),
          //                   errorWidget: (context, _, __) =>
          //                       const Icon(Icons.broken_image, size: 50),
          //                 ),
          //               );
          //             }).toList(),
          //           ),
          //         ),
          //         Divider(),            
            
          //         Text(
          //           "Upload Image: ",
          //           style: Theme.of(context).primaryTextTheme.labelMedium,
          //         ),
            

            
          //         SizedBox(height: 40,),
            
          //         MultiImageUploader(
          //           petId: widget.petId, // e.g. FirebaseAuth.instance.currentUser!.uid
          //           onUploadComplete: (urls) {
          //             print("Uploaded images:");
          //             for (final url in urls) {
          //               print(url);
          //             }
          //           },
          //         ),
                    
          //     ],        
          //   ),
          // ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              controller: controller,
              onPageChanged: _onPageChanged,
              children:_widgetOptions,
            ),
          ),          
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.summarize), label: 'Overview',),
              BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Media', ),
              BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'Questions', ),
              // BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Location'),
            ],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            // selectedItemColor: palette.text1,
            onTap: _onItemTapped,
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor
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

