import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/settings/settings.dart';

class QuestionnaireView extends StatefulWidget {
  final String petId;
  const QuestionnaireView({
    super.key,
    required this.petId
  });

  @override
  State<QuestionnaireView> createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        List<dynamic> petData = settings.petData.value;
        Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==widget.petId,orElse: ()=><String,dynamic>{});
                
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Question 1")
              ],
            ),
          ),
        );
      }
    );
  }
}