import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempoct2025/providers/palette_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {

    return Consumer<ColorPalette>(
      builder: (context,palette,child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Select a Theme"),
          ),
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Card(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("Current Theme: ${palette.currentThemeName}"),
                ),
              ),
              SizedBox(height: 50,),
              Expanded(
                child: ListView.builder(
                  itemCount: palette.themes2.length,
                  itemBuilder: (context,index) {
                    String themeName = palette.themes2.keys.toList()[index];
                    print(themeName);
                
                  return Card(
                    color: palette.themes2[themeName]["cardColor"],
                    child: ListTile(
                      title: Text("Theme $themeName"),
                      trailing: palette.currentThemeName == themeName
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                      onTap: () {
                        palette.selectTheme2(themeName);
                      },
                    ),
                  );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}