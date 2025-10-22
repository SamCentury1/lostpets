import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/components/edit_pet_view.dart';
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
  late bool isPetOwner = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController();
    _settings = Provider.of<SettingsController>(context, listen: false);
    Map<String,dynamic> userData = _settings.userData.value as Map<String,dynamic>;
    List<dynamic> petData = _settings.petData.value;    
    Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
    if (userData["pets"].contains(widget.petId)) {
      setState(() {
        isPetOwner = true;
      });
    }




    _widgetOptions = [
      OverviewView(petId: widget.petId,),
      MediaView(petId: widget.petId, ),
      QuestionnaireView(petId: widget.petId, ),
      // PetMapScreen(petObject: petObject,)
    ];

    
  }

  late PageController controller;



  void _onItemTapped(int index) {
    if (controller.hasClients) {
      controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }  


  File? petImage;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {
        List<dynamic> petData = settings.petData.value;
        Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
        

        return Consumer<AppState>(
          builder: (context,appState,child) {
            return Scaffold(
              appBar: AppBar(
                
                title: Text("Pet Profile"),
                actions: [
                  isPetOwner ? 
                  IconButton(
                    onPressed: () {
                      if (appState.isEditView) {


                        List<dynamic> media = petObject["media"];
                        petObject.update("media", (e) => media);
                        settings.setPetData(settings.petData.value);

                        List<dynamic> questionnaire = petObject["questionnaire"];
                        petObject.update("questionnaire", (e) => questionnaire);


                        setState(() {
                          appState.setIsEditView(false);
                          settings.setPetData(settings.petData.value);
                        });                                         

                        SnackBar snackBar = SnackBar(content: Text("Saved ${petObject["name"]}'s data"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);                        
            
                      } else {
                        setState(() {
                          appState.setIsEditView(true);
                        });                    
                      }
            
                    }, 
                    icon: appState.isEditView ? Icon(Icons.save) : Icon(Icons.edit)
                  ) : SizedBox()
                ],
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,


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
    );
  }

}

