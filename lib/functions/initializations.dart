import 'package:firebase_auth/firebase_auth.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/settings/settings.dart';

class Initializations {

  Future<void> initializeAppData(SettingsController settings, ColorPalette palette, User? user) async {
    Map<String,dynamic> userData = await FirestoreMethods().getFirestoreDocument(user!.uid);
    settings.setUserData(userData);

    List<Map<String,dynamic>> petData = await FirestoreMethods().getPetDocumentsFromDatabase(user!.uid);
    settings.setPetData(petData);
    
    print(petData);
    if (userData.isNotEmpty) {
      palette.selectTheme2(userData["parameters"]["theme"]);
    }
  } 
}