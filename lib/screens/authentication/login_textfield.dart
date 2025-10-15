
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/settings/settings.dart';

class LoginTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);

    final double scalor = Helpers().getScalor(settings);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0*scalor),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0 * scalor),
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
          hintText: hintText,
          hintStyle: TextStyle(
            // color: palette.text1,
            fontSize: 18 * scalor,
          )
        ),
      ),
    );
  }
}