import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/components/multi_image_picker.dart';
import 'package:tempoct2025/screens/image_gallery_screen/image_gallery_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class MediaView extends StatefulWidget {
  final String petId;
  const MediaView({
    required this.petId,
    super.key,
  });

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> with AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;  
  
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<SettingsController>(
      builder: (context,settings,child) {
        List<dynamic> petData = settings.petData.value;
        Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
        List<dynamic> images = petObject["media"];

        return Consumer<AppState>(
          builder: (context,appState,child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
            
              child: SingleChildScrollView(
                  child: Column(
                    children: [
            
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
                        //
                        SizedBox(height: 30,),
                        Builder(
                          builder: (context)  {
                            if (appState.isEditView) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Edit Media",style: Theme.of(context).primaryTextTheme.bodyLarge,),
                                    ),
                                    SizedBox(height: 15,),    

                                    Card(
                                      color: Theme.of(context).cardColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Remove media by pressing on it for one second, then tapping 'Remove' on the bar that appears at the bottom of the screen",
                                            style: Theme.of(context).primaryTextTheme.bodySmall,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15,),                                   
                                    MultiImageUploader(
                                      petId: widget.petId, // e.g. FirebaseAuth.instance.currentUser!.uid
                                      onUploadComplete: (urls) {
                                        print("Uploaded images:");
                                        for (final url in urls) {
                                          print(url);
                                        }
                                      },
                                    ),
                                    Divider()                                    
                                  ],
                                ),
                              );
                              
                            }
                            return SizedBox();
                          },
                        ),                      
                  
            
            
            
                  
            
                        SizedBox(
                          height: appState.isEditView ? MediaQuery.of(context).size.height*1.0 : MediaQuery.of(context).size.height,
                          child: GridView.builder(
                            itemCount: images.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemBuilder: (context, index) {
                              final url = images[index];
                              return GestureDetector(
                                onLongPress: () {
            
                                  if (appState.isEditView) {
                                    SnackBar snackBar = SnackBar(
                                      content: Text("Delete this photo?"),
                                      action: SnackBarAction(
                                        label: "Remove", 
                                        onPressed: () async {
                                          try {
                                            final ref = FirebaseStorage.instance.refFromURL(url);
                                            await ref.delete();
            
                                            // Optionally, also remove it from Firestore or your pet media list
                                            await FirestoreMethods().removePetMedia(widget.petId, url);
            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Photo deleted successfully!')),
                                            );
            
                                            setState(() {
                                              // Remove from your local UI list if needed
                                              images.removeWhere((img) => img == url);
                                            });
                                          } catch (e,t) {
                                            debugPrint('Error deleting photo: $e | stacktrace: $t' );
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Failed to delete photo.')),
                                            );
                                          }                  
                                        }
                                      )
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);                                      
                                  }
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ImageGalleryScreen(
                                        imageUrls: images,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: url,
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ), 
            
                       
                                
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.vertical,
                        //   child: Wrap(
                        //     children: widget.images,
                        //   //   children: petObject["media"].map<Widget>((url) {
                        //   //     return Padding(
                        //   //       padding: const EdgeInsets.all(8.0),
                        //   //       child: CachedNetworkImage(
                        //   //         imageUrl: url,
                        //   //         height: 80,
                        //   //         width: 80,
                        //   //         fit: BoxFit.cover,
                        //   //         placeholder: (context, _) => const Center(
                        //   //           child: CircularProgressIndicator(strokeWidth: 2),
                        //   //         ),
                        //   //         errorWidget: (context, _, __) =>
                        //   //             const Icon(Icons.broken_image, size: 50),
                        //   //       ),
                        //   //     );
                        //   //   }).toList(),
                        //   ),
                        // ),
                     
                        // Divider(),

                        // Text("Upload Images"),

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
    );
  }
}


