import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/resources/auth_service.dart';
import 'package:tempoct2025/screens/authentication/components/auth_provider_tile.dart';
import 'package:tempoct2025/screens/authentication/components/login_button.dart';
import 'package:tempoct2025/screens/authentication/login_textfield.dart';
import 'package:tempoct2025/settings/settings.dart';

// import 'package:scribby_flutter_v2/screens/authentication/components/login_textfield.dart';



class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key,required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signInUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      );

    } on FirebaseAuthException catch (e) {
      if (mounted) {
        debugPrint(e.toString());
        AuthService().authenticationFailed(context, e.code);
      }
    }
    
    // Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        final double scalor = Helpers().getScalor(settings);
        // final List<Map<String,dynamic>> decorationData = [];
        
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                "Welcome back!",
                                // style: TextStyle(color: Colors.grey[700],fontSize: 24),
                                // style: TextStyle(color: palette.text1,fontSize: 24*scalor),

                              ),
                              // SizedBox(height: 15,),
                              LoginTextField(controller: emailController, hintText: 'Email', obscureText: false,),
                              // SizedBox(height: 25,),
                              LoginTextField(controller: passwordController, hintText: 'Password', obscureText: true,),
                              // SizedBox(height: 10,),
                          
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "forgot password?",
                                ),
                              ),
                          
                              // SizedBox(height: 20),
                              LoginButton(onTap: signInUser, body: "Sign In",),
                              // SizedBox(height: 20),
                          
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0 * scalor),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(thickness: 0.5 * scalor, ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0 * scalor,vertical: 18.0 * scalor),
                                      child: Text(
                                        "or continue with",
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(thickness: 0.5 * scalor,),
                                    )                      
                                  ],
                                )
                              ),
                                      
                              // SizedBox(height: 20,),
                          
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
                              // SizedBox(height: 20,),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0 * scalor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("not a member?", ),
                                    SizedBox(width: 5,),
                                    InkWell(
                                      onTap: widget.onTap,
                                      child: Text(
                                        "register now",
                                      ),
                                    )
                                                              
                                  ],
                                ),
                              ),                    
                            ],
                          ),
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