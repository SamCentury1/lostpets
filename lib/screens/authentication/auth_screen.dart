import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/functions/initializations.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/storage_methods.dart';
import 'package:tempoct2025/screens/authentication/login_or_register_screen.dart';
import 'package:tempoct2025/screens/home_screen/home_screen.dart';
import 'package:tempoct2025/settings/settings.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  void initState() {
    super.initState();

    // final SettingsController settings = Provider.of<SettingsController>(context,listen:false);
  
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     // StorageMethods().saveDeviceSizeInfoToSettings(settings);
    //     final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    //     StorageMethods().saveDeviceSizeInfoToSettings(settings);
     
    //   });
    // });        
  }  
  @override
  Widget build(BuildContext context) {

    // final SettingsController settings = Provider.of<SettingsController>(context,listen:false);
    // final ColorPalette palette = Provider.of<ColorPalette>(context,listen:false);


    
  
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // print("Snapshot: $snapshot");


          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint("streaming auth state changes --- loading...");
            return loadingScreen(context);
          }

          if (snapshot.hasError) {
            debugPrint("an error occured at auth screen : ${snapshot.error} | ${snapshot.stackTrace}");
            return errorScreen(context, snapshot.error.toString(),snapshot.stackTrace.toString());
          }

          if (!snapshot.hasData) {
            debugPrint("no authenticated user --- go to login or register screen");
            return LoginOrRegisterScreen();
          }

          final settings = context.read<SettingsController>();
          // final palette  = context.read<ColorPalette>();             

          return FutureBuilder(
            future: Initializations().initializeAppData(settings, snapshot.data), 
            builder: (context, AsyncSnapshot<void> futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return loadingScreen(context);
              }

              if (futureSnapshot.hasError) {
                return errorScreen(context, futureSnapshot.error.toString(), futureSnapshot.stackTrace.toString());
              } 

              return HomeScreen();
            }
          );          
        },
      );
    
  }
}


Widget loadingScreen(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: SizedBox(
      width:MediaQuery.of(context).size.width, 
      height:MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(),
      ),

    )
  );    
}

Widget errorScreen(BuildContext context, String error, String stackTrace) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: SizedBox(
      width:MediaQuery.of(context).size.width, 
      height:MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text("Error: $error")),
          Flexible(child: Text("Stacktrace: $stackTrace")),
        ],
      ),

    )
  );    
}