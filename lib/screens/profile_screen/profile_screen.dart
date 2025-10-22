import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/components/pet_card_widget.dart';
import 'package:tempoct2025/screens/home_screen/home_screen.dart';
import 'package:tempoct2025/screens/new_pet_screen/new_pet_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late List<Map<String,dynamic>> petData = [];
  late SettingsController settings;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // settings = Provider.of<SettingsController>(context, listen: false);
    // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    // petData = FirestoreMethods().getPetDocumentsFromDatabase(userData["uid"]);
    // petData = settings.petData.value as List<Map<String,dynamic>>;
    // List<Map<String,dynamic>> pets = userData
//     print("""
//   user data:
//   $petData

// """);
    // petData = [
    //   {
    //     "uid": "0000000",
    //     "species": "cat",
    //     "breed": "unknown",
    //     "name": "Mimou",
    //     "sex": "male",
    //     "birthYear": 2015,
    //     "vaccines": [{"name":"vaccine 1", "year": 2016},{"name":"vaccine 2", "year": 2017},{"name":"vaccine 3", "year": 2017},],
    //     "diseases" : [{"name":"disease 1", "contagious": false}],
    //     "allowedOutside": false,
    //     "location":{"latitude":"","longitude":""},
    //   }

    // ];


  }







  @override
  Widget build(BuildContext context) {


  return Consumer<SettingsController>(
    builder: (context,settings,child) {

      petData = settings.petData.value as List<Map<String,dynamic>>;

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) => const HomeScreen()),
                ModalRoute.withName('/home'),
              );   
            }, 
            icon: Icon(Icons.arrow_back)
          ),
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          // leading: IconButton(
          //   onPressed: () => {
          //     Navigator.of(context).pop()
          //   }, 
          //   icon: Icon(Icons.arrow_back)
          // ),
          title: const Text("Profile"),
        ),
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          
              Card(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("Welcome Sam!"),
                ),
              ),
              SizedBox(height: 50,),
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Pets",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  )
                ),
              ),
      
              SizedBox(height: 20,),
      
              Column(
                children: petData.map((e) {
                  return PetCardWidget(petId: e["uid"]);
                }).toList(),
              )
      
              // PetCardWidget(petData: petData[0])
      
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewPetScreen())
            );
          },
          child: Icon(Icons.add),
        ),
      );
    }
  );
}

}