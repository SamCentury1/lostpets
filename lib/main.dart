import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/app_lifecycle/app_lifecycle.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/screens/authentication/auth_screen.dart';
import 'package:tempoct2025/screens/home_screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tempoct2025/settings/persistence/local_storage_settings_persistence.dart';
import 'package:tempoct2025/settings/persistence/settings_persistence.dart';
import 'package:tempoct2025/settings/settings.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
    settingsPersistence: LocalStorageSettingsPersistence(),
  ));
}
class MyApp extends StatelessWidget {
    final SettingsPersistence settingsPersistence;
  const MyApp({
    super.key,
    required this.settingsPersistence,
  });

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ColorPalette()),
          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: settingsPersistence
            )..loadStateFromPersistence(),
          ),          
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

