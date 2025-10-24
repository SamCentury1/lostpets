import 'package:flutter/material.dart';
import 'package:tempoct2025/screens/profile_screen/profile_screen.dart';
import 'package:tempoct2025/screens/settings_screen/settings_screen.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Drawer Header'),
          ),


          ListTile(
            title: const Text('My Pets'),
            onTap: () {

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen())
              );
            },
          ),


          ListTile(
            title: const Text('Profile'),
            onTap: () {

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen())
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen())
              );  
            },
          ),
        ],
      ),
    );
  }
}