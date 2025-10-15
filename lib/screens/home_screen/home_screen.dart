import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/auth_service.dart';
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
                PopupMenuButton(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(value: 0, child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        AuthService().signOut();
                      },
                      child: Text("Sign Out"),
                    )),
                    const PopupMenuItem(value: 1, child: Text('Item 2')),
                    const PopupMenuItem(value: 2, child: Text('Item 3')),
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
              )
            ],
          ),
        );
      }
    );
  }
}