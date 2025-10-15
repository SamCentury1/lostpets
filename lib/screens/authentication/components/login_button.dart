import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/settings/settings.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  final String body;
  const LoginButton({
    super.key, 
    required this.onTap, 
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    late SettingsController settings = Provider.of<SettingsController>(context, listen:false);
    final double scalor = Helpers().getScalor(settings);
        
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0*scalor),
      child: ElevatedButton(
        onPressed: onTap,
        
        child: Container(
          padding: EdgeInsets.all(15.0*scalor),
          margin: EdgeInsets.symmetric(horizontal: 25.0*scalor),
          decoration: BoxDecoration(
          //   color: palette.widget1,
            borderRadius: BorderRadius.circular(8.0*scalor)
          ),
          child: Center(
            child: Text(
              body,
            ),
          ),
      
      
      
        ),
      
        style: ElevatedButton.styleFrom(
          // shadowColor: palette.widgetShadow1,
      
        
          textStyle: TextStyle(
            fontSize: 24*scalor
          ),                                    
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0 * scalor)),
          ),
        ),       
      ),
    );
  }
}