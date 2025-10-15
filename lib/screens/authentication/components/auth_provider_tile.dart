import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/settings/settings.dart';


class AuthProviderTile extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;
  const AuthProviderTile({
    super.key,
    required this.onTap,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    late SettingsController settings = Provider.of<SettingsController>(context, listen:false);
    final double scalor = Helpers().getScalor(settings);    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80 * scalor,
        height: 80 * scalor,
        
        child: IconButton(
          icon: Icon(iconData, size: 50*scalor,),
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            // shadowColor: palette.widgetShadow1,
            textStyle: TextStyle(
              fontSize: 24*scalor
            ),                                    
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0 * scalor)),
            ),
            minimumSize: Size(80.0*scalor,80.0*scalor)
          ),           
          // child: Icon(iconData, size: 50 * scalor, color: palette.text1,)
        ),
      ),
    );
  }
}