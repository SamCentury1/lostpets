import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/screens/notifications_screen/notifications_screen.dart';
import 'package:tempoct2025/screens/profile_screen/profile_screen.dart';
import 'package:tempoct2025/screens/settings_screen/settings_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
        // List<dynamic> notifications = userData["notifications"];
        List<dynamic> notifications = settings.requestsData.value;

        

        print("notifications: $notifications");

        return Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).drawerTheme.backgroundColor),
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
        
              ListTile(
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NotificationsScreen())
                  );  
                },
                trailing: notificationsBubble(notifications)
              ),          
            ],
          ),
        );
      }
    );
  }
}

Widget notificationsBubble(List<dynamic> notifications) {
  List<dynamic> pendingNotifications = notifications.where((e)=>e["viewed"]==false).toList();
  int pendingNotificationsNumber = pendingNotifications.length;
  Widget res = SizedBox();
  if (pendingNotificationsNumber > 0) {
    res = SizedBox(
      width: 25,
      height: 25,
      child: CircleAvatar(
        backgroundColor: Colors.red,
        child: Text(pendingNotificationsNumber.toString(), style: TextStyle(color: Colors.white, fontSize: 16),),
      ),
    );  
  }
  return res;

}