import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/app_lifecycle/app_lifecycle.dart';
import 'package:tempoct2025/functions/initializations.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/screens/authentication/auth_screen.dart';
import 'package:tempoct2025/screens/home_screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tempoct2025/settings/persistence/local_storage_settings_persistence.dart';
import 'package:tempoct2025/settings/persistence/settings_persistence.dart';
import 'package:tempoct2025/settings/settings.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("success init fb!");
  } catch (e,s) {
    debugPrint("error init fb: $e | $s");
  }
  

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );
  final palette = ColorPalette();


  print(" *  * *  * *  * *  * *  * *  * *  *");
  print("------------- BEFORE ---------------");
  print("deviceSizeInfo   ${settings.deviceSizeInfo.value}");
  print("theme            ${settings.theme.value}");
  print("userData         ${settings.userData.value}");
  print("petData          ${settings.petData.value}");
  print(" *  * *  * *  * *  * *  * *  * *  *");

  await settings.loadStateFromPersistence();
  palette.selectTheme2(settings.theme.value);

  print(" *  * *  * *  * *  * *  * *  * *  *");
  print("------------- AFTER ---------------");
  print("deviceSizeInfo   ${settings.deviceSizeInfo.value}");
  print("theme            ${settings.theme.value}");
  print("userData         ${settings.userData.value}");
  print("petData          ${settings.petData.value}");  
  print(" *  * *  * *  * *  * *  * *  * *  *");  
  

  runApp(MyApp(
    settings: settings,
    settingsPersistence: LocalStorageSettingsPersistence(),
    palette: palette,
  ));
}
class MyApp extends StatefulWidget {
    final SettingsController settings;
    final SettingsPersistence settingsPersistence;
    final ColorPalette palette;
  const MyApp({
    super.key,
    required this.settings,
    required this.settingsPersistence,
    required this.palette,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool _isPreloaded = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_isPreloaded) {
  //     Initializations().preloadImages(context, widget.preloadedUrls).then((_) {
  //       setState(() => _isPreloaded = true);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (_) => ColorPalette()),
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider.value(value: widget.palette,),
          Provider<SettingsController>.value(value: widget.settings,),
          // Provider<SettingsController>(
          //   lazy: false,
          //   create: (context) => SettingsController(
          //     persistence: widget.settingsPersistence
          //   )..loadStateFromPersistence(),
          // ),          
        ],
        child: Consumer<ColorPalette>(
          builder: (context, palette, _) {
     
            return MaterialApp(
              title: 'Flutter Demo',
              theme: palette.currentTheme,
              home: const AuthScreen(),
            );
          },
        ),
      ),
    );
  }
}

