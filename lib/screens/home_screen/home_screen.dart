import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/auth_service.dart';
import 'package:tempoct2025/screens/authentication/auth_screen.dart';
import 'package:tempoct2025/screens/components/main_drawer.dart';
import 'package:tempoct2025/screens/components/pet_map.dart';
import 'package:tempoct2025/screens/profile_screen/profile_screen.dart';
import 'package:tempoct2025/screens/settings_screen/settings_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Consumer<ColorPalette>(
      builder: (context,palette,child) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            // leading: IconButton(
            //   onPressed: () => {
            //     Navigator.of(context).pop()
            //   }, 
            //   icon: Icon(Icons.arrow_back)
            // ),
            title: const Text("Home"),
            actions: [
              PopupMenuButton<int>(
                onSelected: (value) async {
                  if (value == 0) {
                    await AuthService().signOut();
                    if (!mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                      (route) => false,
                    );
                  } else if (value==1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SettingsScreen())
                    );                    
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 0, child: Text("Sign Out")),
                  PopupMenuItem(value: 1, child: Text("Settings")),
                  PopupMenuItem(value: 2, child: Text("Item 3")),
                ],
              ),
                       
            ],
          ),
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: MainDrawer(),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // SizedBox(height:50),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                    
                        Text(
                          "Lost pets",
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                                    
                        Text(
                          "This map shows the location of lost pets' homes",
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),              
                                    
                                    
                        Text(
                          "If you see a pet roaming alone, check whether it looks like any of the pets listed here",
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),   
                      ],
                    ),
                  ),
                ),
              ),
           



              Expanded(
                
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width*0.95,
                    // height: MediaQuery.of(context).size.height*0.7,
                    // height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PetMapScreen(petObject: null,)
                    ),                
                    
                  ),
                ),
              )
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => const PetMapScreen(petObject: null,))
              //     );
              //   }, 
              //   child: Text("Pets")
              // ),              
            ],
          ),
        );
      }
    );
  }
}