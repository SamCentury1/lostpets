import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/auth_service.dart';
import 'package:tempoct2025/screens/authentication/auth_screen.dart';
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
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 0, child: Text("Sign Out")),
                  PopupMenuItem(value: 1, child: Text("Item 2")),
                  PopupMenuItem(value: 2, child: Text("Item 3")),
                ],
              ),
                       
            ],
          ),
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Card(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Welcome Home"),
                ),
              ),
              SizedBox(height: 50,),

              Text("Text 1"),
              Text("Text 2"),
              Text("Text 3"),

              Card(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfileScreen())
                    );
                  }, 
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SettingsScreen())
                  );
                }, 
                child: Text("Settings")
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PetMapScreen(petObject: null,))
                  );
                }, 
                child: Text("Pets")
              ),              
            ],
          ),
        );
      }
    );
  }
}