
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/settings/settings.dart';


class AuthErrorDialog extends StatelessWidget {
  final String errorTitle;
  final List<String> errors;
  const AuthErrorDialog({
    super.key,
    required this.errorTitle,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {

    late SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    late double scalor = Helpers().getScalor(settings);
    final double sizeFactor = scalor;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0 * scalor))),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.6*scalor,
            colors: [Colors.blue,Colors.purple]
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
        ),
        child: Padding(
          padding:  EdgeInsets.fromLTRB(22.0 * sizeFactor,8.0 * sizeFactor,22.0 *sizeFactor, 8.0 * sizeFactor,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  errorTitle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0 * sizeFactor),
                child: Divider(thickness: 1.0 *sizeFactor, ),
              ),

              Column(
                children: displayErrors(errors, sizeFactor),
              ),              

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0 * sizeFactor),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12.0 * sizeFactor, 4.0 * sizeFactor, 12.0 * sizeFactor, 4.0 * sizeFactor),
                        child: Text(
                          "Okay",
                          
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}

List<Widget> displayErrors(List<String> errors, double scalor) {
  List<Widget> errorTextWidgets = [];
  for (String error in errors) {
    late Widget errorTextWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,      
      children: [
        Text(
          error,
          textAlign: TextAlign.start,
        ),
        Divider(thickness: 0.5 * scalor,)
      ],
    );
    errorTextWidgets.add(errorTextWidget);
  }
  return errorTextWidgets;
}