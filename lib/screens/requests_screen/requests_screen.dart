import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/authentication/auth_screen.dart';
import 'package:tempoct2025/screens/components/pet_card.dart';
import 'package:tempoct2025/screens/notifications_screen/notifications_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class RequestsScreen extends StatefulWidget {
  final String requestId;
  const RequestsScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  late SettingsController settings;
  Map<String,dynamic> requestData = {};


  String requestor = "";
  String titleText = "";
  List<dynamic> petData = [];
  String message = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context, listen: false);
    // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    // List<dynamic> notifications = userData["notifications"];
    // requestData = notifications.firstWhere((e)=>e["uid"]==widget.requestId,orElse: ()=><String,dynamic>{});

    // if (requestData.isNotEmpty) {

    //   String requestorId = requestData["fromId"];

    //   Map<String,dynamic> requestorData = FirestoreMethods().getUserData(requestorId);
      
    // }

  }

  Future<void> onAccept() async {
    FirestoreMethods().updateRequestDocument(settings, widget.requestId, "status", "accepted");

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    List<dynamic> pets = userData["pets"];
    List<dynamic> requestPets = petData.map((e)=>e["uid"]).toList();
    pets.addAll(requestPets);

    FirestoreMethods().updateUserDoc(settings, "pets", pets);


    for (int i=0; i<requestPets.length; i++) {
      String petId = requestPets[i];
      FirestoreMethods().addGuardianToPet(userData["uid"], petId);
    }

    List<dynamic> userPetData = settings.petData.value;
    userPetData.addAll(petData);
    settings.setPetData(userPetData);
  }

    
  Future<void> onDecline() async {
    FirestoreMethods().updateRequestDocument(settings, widget.requestId, "status", "declined");
  }


  Future<void> getRequestData(SettingsController settings, String requestId) async {
    // Map<String,dynamic> res = {};
    // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    List<dynamic> notifications = settings.requestsData.value;
    requestData = notifications.firstWhere((e)=>e["uid"]==widget.requestId,orElse: ()=><String,dynamic>{});

    if (requestData.isNotEmpty) {

      String requestorId = requestData["sourceId"];

      Map<String,dynamic>? requestorData = await FirestoreMethods().getUserData(requestorId);

      if (requestorData!=null || requestorData!.isNotEmpty) {
        requestor = "${requestorData["firstName"]} ${requestorData["lastName"]}";
        titleText = "${requestData["type"]} request";
        message = requestData["message"];
      }

      // for (int i=0; i<requestData["pets"]; i++) {
      //   String petId = requestData["pets"][i];

      // }
      petData = await FirestoreMethods().retrieveSelectPetDocuments(requestData["pets"]);

      await FirestoreMethods().updateRequestDocument(settings,widget.requestId,"viewed",true);

      print("pet data: $petData");
      
    }    


  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRequestData(settings,widget.requestId),
      builder: (context, asyncSnapshot) {

        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(),),));
        }
  
        if (asyncSnapshot.hasError) {
          debugPrint("Error: ${asyncSnapshot.error.toString()}");
          debugPrint("stack: ${asyncSnapshot.stackTrace.toString()}");
          return Scaffold(body:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("An error occured: ${asyncSnapshot.error.toString()}"),
              Text("Stacktrace: ${asyncSnapshot.stackTrace.toString()}")
            ]),
          ));
        }        
        return Scaffold(
          appBar: AppBar(
            title: Text(titleText),
            leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(builder: (BuildContext context) => const AuthScreen()),
                  ModalRoute.withName('/home'),
                );   
              }, 
              icon: Icon(Icons.arrow_back)
            ),            
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 70,),
                Row(
                  children: [
                    Text(
                      "From: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                      ),
                    ),
                    Text(
                      requestor,
                      style: TextStyle(
                        fontSize: 22
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(height: 10,),
                Column(
                  children: petData.map((e) {
                    return PetCard(petData: e);
                  }).toList()
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 228, 228, 228),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))
                          )
                        ),
                        onPressed: () {
                          onAccept();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const NotificationsScreen())
                          );                            
                        }, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(backgroundColor: Colors.green,radius: 14.0, child: Icon(Icons.check, color: Colors.white,)),
                            SizedBox(width: 10,),
                            Text("Accept")                        
                          ],
                        ),
                        // child: Text("Accept")
                      ),
                    ),
            
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 228, 228, 228),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))
                          )
                        ),
                        onPressed: ()  {
                          onDecline();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const NotificationsScreen())
                          );                              
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(backgroundColor: Colors.red,radius: 14.0, child: Icon(Icons.close, color: Colors.white,)),
                            SizedBox(width: 10,),
                            Text("Decline")                        
                          ],
                        ),
                        // child: Text("Accept")
                      ),
                    ),             
                  ],
                )
              ],
            ),
          ),        
        );
      }
    );
  }
}