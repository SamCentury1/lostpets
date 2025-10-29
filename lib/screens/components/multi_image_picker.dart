import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/settings/settings.dart';

class MultiImageUploader extends StatefulWidget {
  final String petId;
  final void Function(List<String> urls)? onUploadComplete;

  const MultiImageUploader({
    super.key,
    required this.petId,
    this.onUploadComplete,
  });

  @override
  State<MultiImageUploader> createState() => _MultiImageUploaderState();
}

class _MultiImageUploaderState extends State<MultiImageUploader> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<XFile> _images = [];
  List<double> _uploadProgress = [];
  bool _isLoading = false;

  late SettingsController _settings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _settings = Provider.of<SettingsController>(context,listen: false);
  }
  

  Future<void> _pickImages() async {
    setState(() => _isLoading = true);

    try {
      final List<XFile> selected = await _picker.pickMultiImage();

      if (selected.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _images = selected;
        _uploadProgress = List.filled(selected.length, 0.0);
      });

      await _uploadImages();
    } catch (e,s) {
      debugPrint("Error picking images: $e | $s");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadImages() async {
    List<String> downloadUrls = [];

    for (int i = 0; i < _images.length; i++) {
      XFile image = _images[i];
      File file = File(image.path);

      try {
        final ref = _storage
            .ref()
            .child('user_uploads/${widget.petId}/${DateTime.now().millisecondsSinceEpoch}_${image.name}');

        final uploadTask = ref.putFile(file);

        uploadTask.snapshotEvents.listen((event) {
          final progress = event.bytesTransferred / event.totalBytes;
          setState(() => _uploadProgress[i] = progress);
        });

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        downloadUrls.add(downloadUrl);
      } catch (e) {
        debugPrint("Error uploading image $i: $e");
      }
    }

    FirestoreMethods().updatePetMedia(widget.petId,downloadUrls);

    widget.onUploadComplete?.call(downloadUrls);

    setState(() => _isLoading = false);

    setState(() {
      List<dynamic> petData = _settings.petData.value;  
      Map<String,dynamic> petObject = Helpers().getPetObject(_settings,widget.petId);
      List<dynamic> media = petObject["media"];
      media.addAll(downloadUrls);
      petObject.update("media", (v)=>media);
      _settings.setPetData(petData);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))
            )
          ),
          onPressed: _isLoading ? null : _pickImages,
          icon: const Icon(Icons.photo_library),
          label: const Text('Add Images'),
        ),
        const SizedBox(height: 12),
        if (_isLoading && _images.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        if (_images.isNotEmpty)
          SizedBox(
            height: 150,
            width: 400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_images[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: _uploadProgress[index],
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
