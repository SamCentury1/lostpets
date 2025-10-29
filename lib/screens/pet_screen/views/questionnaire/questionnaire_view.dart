import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/components/questionnaire_card.dart';
import 'package:tempoct2025/settings/settings.dart';

class QuestionnaireView extends StatefulWidget {
  final String petId;
  const QuestionnaireView({
    super.key,
    required this.petId,
  });

  @override
  State<QuestionnaireView> createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView> {

  List<dynamic> questionnaire = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SettingsController _settings= Provider.of<SettingsController>(context,listen: false);
    List<dynamic> petData = _settings.petData.value;
    Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
    questionnaire = petObject["questionnaire"];    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        List<dynamic> petData = settings.petData.value;
        Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
        List<dynamic> _questionnaire = petObject["questionnaire"];

        return Consumer<AppState>(
          builder: (context,appState,child) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30,),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Characteristics",style: Theme.of(context).primaryTextTheme.bodyLarge,),
                      ),
                    ),
                    SizedBox(height: 15,),                       
    

                    Builder(
                      builder: (context) {
                        if (appState.isEditView) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
 
                            
                                Card(
                                  color: Theme.of(context).cardColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Create a questionnaire of unique characteristics to help users identify your pet",
                                        style: Theme.of(context).primaryTextTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0))
                                    )
                                  ),                      
                                  onPressed: () {
                                    _showQuestionnaireDialog(context,settings);
                                    print("open a modal to add a question");
                                  }, 
                                  child: Text("Add Characteristic")
                                ),
                                SizedBox(height: 15,),
                                Divider()      
                              ],
                            ),
                          );

                        } else {
                          return SizedBox();
                        }
                      }
                    ),
                

                            
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Builder(
                        builder: (context) {
                          if (questionnaire.isEmpty) {
                            return Text("No questions to dispaly yet");
                          } else {
                            return Column(
                              children: _questionnaire.map((e) {
                                return QuestionnaireCard(petId:widget.petId, questionnaireObject: e);
                              }).toList(),
                            );
                          }
                        }
                      ),
                    ),                            
                  ],
                )
              ),
            );
          }
        );
      }
    );
  }


  void _showQuestionnaireDialog(BuildContext context, SettingsController settings,) {

    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New Characteristic"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                maxLines: 3,
                controller: questionController,
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
                  hintText: "Question",
                  hintStyle: TextStyle(
                    // color: palette.text1,
                    fontSize: 18,
                  )
                ),
              ),

              SizedBox(height: 10,),

              TextField(
                controller: answerController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0 ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: const Color.fromARGB(73, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: const Color.fromARGB(71, 0, 0, 0)),
                  ),
                  // focusColor: palette.inputFieldTextColor,
                  // fillColor: palette.inputFieldBgColor,
                  filled: true,
                  hintText: "Answer",
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
              onPressed: () {
                Navigator.pop(context);
                if (questionController.text != "" && answerController.text != "") {
                  setState(() {
                    questionnaire.add({"question":questionController.text, "answer":answerController.text});
                    FirestoreMethods().updatePetQuestionnaire(settings, widget.petId, questionnaire);                    
                  });
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

}

