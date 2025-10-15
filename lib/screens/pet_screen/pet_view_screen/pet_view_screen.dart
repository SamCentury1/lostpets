import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/settings/settings.dart';

class PetViewScreen extends StatefulWidget {
  final Map<String,dynamic> petObject;
  const PetViewScreen({
    super.key,
    required this.petObject
  });

  @override
  State<PetViewScreen> createState() => _PetViewScreenState();
}

class _PetViewScreenState extends State<PetViewScreen> {

  // late SettingsController settings;
  File? petImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // settings = Provider.of<SettingsController>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Profile"),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
            // 🐶 Pet Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        petImage != null ? FileImage(petImage!) : null,
                    child: petImage == null
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
            const SizedBox(height: 24),          
        ],        
      ),
    );
  }
}