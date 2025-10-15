import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/settings/settings.dart';

class MediaView extends StatefulWidget {
  final String petId;
  final List<Widget> images;
  const MediaView({
    required this.petId,
    required this.images,
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

        return SizedBox(
          height: MediaQuery.of(context).size.height,

          child: SingleChildScrollView(
              child: Column(
                children: [
              



              
                    Text(
                      "Images: ",
                      style: Theme.of(context).primaryTextTheme.labelMedium,
                    ),
                            
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        children: widget.images,
                      //   children: petObject["media"].map<Widget>((url) {
                      //     return Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: CachedNetworkImage(
                      //         imageUrl: url,
                      //         height: 80,
                      //         width: 80,
                      //         fit: BoxFit.cover,
                      //         placeholder: (context, _) => const Center(
                      //           child: CircularProgressIndicator(strokeWidth: 2),
                      //         ),
                      //         errorWidget: (context, _, __) =>
                      //             const Icon(Icons.broken_image, size: 50),
                      //       ),
                      //     );
                      //   }).toList(),
                      ),
                    ),
                    Divider(),            
              
                    // Text(
                    //   "Upload Image: ",
                    //   style: Theme.of(context).primaryTextTheme.labelMedium,
                    // ),
              
              
              
                    SizedBox(height: 40,),
              
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
}