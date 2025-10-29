import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/settings/settings.dart';

class QuestionnaireCard extends StatefulWidget {

  final String petId;
  final Map<String,dynamic> questionnaireObject;
  const QuestionnaireCard({
    super.key,
    required this.petId,
    required this.questionnaireObject,
  });

  @override
  State<QuestionnaireCard> createState() => _QuestionnaireCardState();
}

class _QuestionnaireCardState extends State<QuestionnaireCard> {

  late SettingsController settings;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context,listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context,appState,child) {
        return Padding(
          padding: EdgeInsets.all(0.0),
          child: Stack(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.questionnaireObject["question"],
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.questionnaireObject["answer"],
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        )
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: appState.isEditView
                        ? Center(
                          child: IconButton(
                            padding: EdgeInsets.zero, // removes default padding
                            constraints: BoxConstraints(), // prevents extra spacing                            
                            onPressed: () {
                              print("remove this bitch");
                              _showRemoveQuestionDialog(context,widget.petId,widget.questionnaireObject);
                            }, 
                            icon: Icon(Icons.highlight_remove_sharp,size: 30,)
                          ),
                        ) : SizedBox(),
                      )                        
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

  void _showRemoveQuestionDialog(BuildContext context, String petId, Map<String,dynamic> questionnaireObject) {

    SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    List<dynamic> petData = settings.petData.value;
    Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==petId,orElse: ()=><String,dynamic>{});
    List<dynamic> questionnaire = petObject["questionnaire"];
    int questionIndex = questionnaire.indexOf(questionnaireObject);
  
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove Characteristic"),
          content: Text("Are you sure you want to delete this characteristic?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                questionnaire.removeAt(questionIndex);
                FirestoreMethods().updatePetQuestionnaire(settings,petId,questionnaire);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }