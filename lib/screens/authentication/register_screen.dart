import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:scribby_flutter_v2/screens/authentication/components/login_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/resources/auth_service.dart';
import 'package:tempoct2025/screens/authentication/components/auth_provider_tile.dart';
import 'package:tempoct2025/screens/authentication/components/login_button.dart';
import 'package:tempoct2025/screens/authentication/login_textfield.dart';
import 'package:tempoct2025/settings/settings.dart';



class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      List<String> errors = [];
      if (password1Controller.text != password2Controller.text) {
        errors.add("passwords don't match");
      }

      if (password1Controller.text.length <= 6) {
        errors.add("passowrd must be over 6 characters");        
      }

      if (errors.isEmpty) {

        await AuthService().registerUserManually(emailController.text, password1Controller.text,usernameController.text);
   
      } else {
        AuthService().showLoginFailedDialog(context, "Errors", errors);
      }

    } on FirebaseAuthException catch (e) {
      if (mounted) {
        debugPrint(e.toString());
        AuthService().authenticationFailed(context, e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<SettingsController>(
      builder: (context,settings,child) {
        final double scalor = Helpers().getScalor(settings);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context,constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                              
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Welcome!",
                              ),
                            
                              LoginTextField(controller: usernameController, hintText: 'Username', obscureText: false,),
                          
                              LoginTextField(controller: emailController, hintText: 'Email', obscureText: false,),
                            
                              LoginTextField(controller: password1Controller, hintText: 'Password', obscureText: true,),
                          
                              LoginTextField(controller: password2Controller, hintText: 'Confirm Password', obscureText: true,),
                            
                              LoginButton(onTap: registerUser, body: "Register",),
                          
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0 * scalor),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(thickness: 0.5*scalor,),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0 * scalor, vertical: 18.0 * scalor),
                                      child: Text(
                                        "or continue with",
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(thickness: 0.5*scalor,),
                                    )                      
                                  ],
                                )
                              ),
                          
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AuthProviderTile(
                                    onTap: () => AuthService().signInWithGoogle(context),
                                    iconData: Icons.g_mobiledata,
                                  ),
                                  SizedBox(width: 10,),
                            
                                  AuthProviderTile(
                                    onTap: () => AuthService().signInWithApple(context),
                                    iconData: Icons.apple,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0 * scalor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("already a member?", 
                                    ),
                                    SizedBox(width: 5,),
                                    InkWell(
                                      onTap: widget.onTap,
                                      child: Text(
                                        "login now",
                                      ),
                                    )
                                                              
                                  ],
                                ),
                              )
                            ],
                          ),
                              
                          // Expanded(flex: 4, child:SizedBox())
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          )
        );
      }
    );
  }
}