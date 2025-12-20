import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/settings/settings.dart';

class NewRequestDialog extends StatefulWidget {
  const NewRequestDialog({super.key});

  @override
  State<NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NewRequestDialog> {

  late TextEditingController messageController;
  late TextEditingController emailController;
  late List<String> requestTypes = ["co-ownership"];
  late String requestType = requestTypes[0];
  Map<String,dynamic> userData = {};

  late SettingsController settings;
  late List<dynamic> petData = [];
  late List<dynamic> petDropdwonObjects = [];
  late List<dynamic> selectedPets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageController = TextEditingController();
    emailController = TextEditingController();
    settings = Provider.of<SettingsController>(context,listen: false);
    userData = settings.userData.value as Map<String,dynamic>;
    petData = settings.petData.value;

    petDropdwonObjects = petData.map((e) {
      return {"uid":e["uid"],"name":e["name"]};
    }).toList();
    selectedPets = [];
    print(petDropdwonObjects);

  }

  @override
  Widget build(BuildContext context) {
        return AlertDialog(
          title: Text("New Request"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [


              SizedBox(height: 10,),

              Text("Selected:"),
              Column(
                children: selectedPets.map((e) {
                  return Text(e["name"]);
                }).toList()
              ),

              DropdownButtonFormField<Object>(
                value:null,
                decoration: const InputDecoration(
                  labelText: "Pets",
                  border: OutlineInputBorder(),
                ),
                menuMaxHeight: 250,
                items: petDropdwonObjects
                    .map((obj) =>
                        DropdownMenuItem(value: obj["uid"], child: Text(obj["name"])))
                    .toList(),
                onChanged: (value) {
                  Map<String,dynamic> obj = petDropdwonObjects.firstWhere((e)=>e["uid"]==value!,orElse: ()=><String,dynamic>{}); 
                  setState(() {

                    selectedPets.add(obj);
                    petDropdwonObjects.remove(obj);
                    print(selectedPets);
                  });
                },
              ),

              SizedBox(height: 30,),

              TextField(
                controller: emailController,
                obscureText: false,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0 ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  // focusColor: palette.inputFieldTextColor,
                  // fillColor: palette.inputFieldBgColor,
                  filled: true,
                  hintText: "recipient",
                  hintStyle: TextStyle(
                    // color: palette.text1,
                    fontSize: 18 ,
                  )
                ),
              ),              

              SizedBox(height: 30,),
                       

              DropdownButtonFormField<String>(
                value: requestType,
                decoration: const InputDecoration(
                  labelText: "Request Type",
                  border: OutlineInputBorder(),
                ),
                menuMaxHeight: 250,
                items: requestTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  
                  setState(() {
                    requestType = value!;
                  });
                },
              ),

              SizedBox(height: 20,),


              TextField(
                maxLines: 3,
                controller: messageController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0 ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: const Color.fromARGB(101, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: const Color.fromARGB(75, 0, 0, 0)),
                  ),
                  // focusColor: palette.inputFieldTextColor,
                  // fillColor: palette.inputFieldBgColor,
                  filled: true,
                  hintText: "Optional Message",
                  hintStyle: TextStyle(
                    // color: palette.text1,
                    fontSize: 18,
                  )
                ),
              ),              
         
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String? targetId = await FirestoreMethods().validateTargetEmail(emailController.text);
                if (emailController.text!="" && targetId != null) {
                  Map<String,dynamic> requestObject = {
                    "message": messageController.text,
                    "pets": selectedPets.map((e)=>e["uid"]).toList(),
                    "sourceId": userData["uid"],
                    "targetId": targetId,
                    "type": requestType,
                  };
                  await FirestoreMethods().createRequestDocument(requestObject);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This email is not valid')),
                  );
                }
                
              },
              child: const Text("Send Request"),
            ),
          ],
        );
  }
}