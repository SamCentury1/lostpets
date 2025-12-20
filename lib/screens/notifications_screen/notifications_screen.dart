import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/screens/notifications_screen/components/new_request_dialog.dart';
import 'package:tempoct2025/screens/requests_screen/requests_screen.dart';
import 'package:tempoct2025/settings/settings.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  late SettingsController settings;
  List<dynamic> pendingNotifications = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context,listen: false);
    // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    List<dynamic> notifications = settings.requestsData.value;
    pendingNotifications = notifications.where((e)=>e["status"]=="pending").toList();

  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Column(
        children: [
          Text("Notifications"),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  pendingNotifications.isEmpty ? Text("No pending notifications") : 
            
            Column(
              children: pendingNotifications.map((e) {
                return notificationCard(context, notificationData: e);
              }).toList(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // print("send a new request");
          showDialog(
            context: context, 
            builder: (builder) {
              return NewRequestDialog();
            }
          );
        }
      ),
    );
  }
}

Widget notificationCard(BuildContext context, {required Map<String,dynamic> notificationData}) {

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        )
      ),
      onPressed: () {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => RequestsScreen(requestId: notificationData["uid"],)),
          ModalRoute.withName('/home'),
        );      
      },
      child: Text("Co-ownership request"),
    ),
  );
}