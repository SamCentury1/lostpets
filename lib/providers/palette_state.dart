import 'package:flutter/material.dart';

class ColorPalette extends ChangeNotifier {


  late Map<String,dynamic> themes2 = {
      "red": {
        "seedColor" : Colors.red,
        "cardColor" : const Color.fromARGB(255, 245, 122, 113),
        "appBarThemeColor" : Colors.red,
        "appBarTextColor": Colors.white,
        "dividerColor": const Color.fromARGB(255, 53, 53, 53),
        "scaffoldBackgroundColor" : const Color.fromARGB(255, 247, 210, 207),
        "primaryTextThemeColor" : const Color.fromARGB(255, 17, 17, 17),
        "elevatedButtonBackgroundColor" : const Color.fromARGB(255, 196, 28, 16),
        "elevatedButtonForegroundColor" : const Color.fromARGB(255, 233, 233, 233),
      },

      "orange": {
        "seedColor" : Colors.orange,
        "cardColor" : const Color.fromARGB(255, 248, 187, 96),
        "appBarThemeColor" : Colors.orange,
        "appBarTextColor": Colors.white,
        "dividerColor": const Color.fromARGB(255, 61, 61, 61),
        "scaffoldBackgroundColor" : const Color.fromARGB(255, 247, 222, 184),
        "primaryTextThemeColor" : const Color.fromARGB(255, 17, 17, 17),
        "elevatedButtonBackgroundColor" : const Color.fromARGB(255, 192, 115, 0),
        "elevatedButtonForegroundColor" : const Color.fromARGB(255, 233, 233, 233),
      },

      "yellow": {
        "seedColor" : Colors.yellow,
        "cardColor" : const Color.fromARGB(255, 255, 243, 131),
        "appBarThemeColor" : Colors.yellow,
        "appBarTextColor": const Color.fromARGB(255, 0, 0, 0),
        "dividerColor": const Color.fromARGB(255, 53, 53, 53),
        "scaffoldBackgroundColor" : const Color.fromARGB(255, 248, 240, 171),
        "primaryTextThemeColor" : const Color.fromARGB(255, 17, 17, 17),
        "elevatedButtonBackgroundColor" : const Color.fromARGB(255, 196, 176, 3),
        "elevatedButtonForegroundColor" : const Color.fromARGB(255, 233, 233, 233),
      },

      "green": {
        "seedColor" : Colors.green,
        "cardColor" : const Color.fromARGB(255, 176, 255, 179),
        "appBarThemeColor" : Colors.green,
        "appBarTextColor": Colors.white,
        "dividerColor": const Color.fromARGB(255, 48, 48, 48),
        "scaffoldBackgroundColor" : const Color.fromARGB(255, 213, 248, 214),
        "primaryTextThemeColor" : const Color.fromARGB(255, 17, 17, 17),
        "elevatedButtonBackgroundColor" : const Color.fromARGB(255, 11, 90, 13),
        "elevatedButtonForegroundColor" : const Color.fromARGB(255, 233, 233, 233),
      },

      "blue": {
        "seedColor" : Colors.blue,
        "cardColor" : const Color.fromARGB(255, 107, 175, 231),
        "appBarThemeColor" : Colors.blue,
        "appBarTextColor": Colors.white,
        "dividerColor": const Color.fromARGB(255, 187, 187, 187),
        "scaffoldBackgroundColor" : const Color.fromARGB(255, 195, 222, 243),
        "primaryTextThemeColor" : const Color.fromARGB(255, 17, 17, 17),
        "elevatedButtonBackgroundColor" : const Color.fromARGB(255, 5, 101, 179),
        "elevatedButtonForegroundColor" : const Color.fromARGB(255, 233, 233, 233),
      },

      "purple": {
        "seedColor" : Colors.purple,
        "cardColor" : const Color.fromRGBO(241, 160, 255, 1),
        "appBarThemeColor" : Colors.purple,
        "appBarTextColor": Colors.white,
        "dividerColor": const Color.fromARGB(255, 14, 14, 14),
        "scaffoldBackgroundColor" : const Color.fromARGB(255, 229, 199, 235),
        "primaryTextThemeColor" : const Color.fromARGB(255, 17, 17, 17),
        "elevatedButtonBackgroundColor" : Colors.purple,
        "elevatedButtonForegroundColor" : const Color.fromARGB(255, 233, 233, 233),
      },                                                                 

  };

  late String _currentThemeName = "red";
  String get currentThemeName => _currentThemeName;

  late ThemeData _currentTheme = ThemeData (
    colorScheme: ColorScheme.fromSeed(
      primary: Colors.black,
      secondary: Colors.grey,
      seedColor: themes2[_currentThemeName]["seedColor"]
    ),
    cardTheme: CardThemeData(
      shadowColor: Colors.black,
      elevation: 7.0
    ),    
    dividerColor: themes2[_currentThemeName]["dividerColor"],
    cardColor: themes2[_currentThemeName]["cardColor"],
    appBarTheme: AppBarTheme(
      color: themes2[_currentThemeName]["appBarThemeColor"],
      foregroundColor: themes2[_currentThemeName]["appBarTextColor"],
    ),
    scaffoldBackgroundColor: themes2[_currentThemeName]["scaffoldBackgroundColor"],

    primaryTextTheme: TextTheme(
        labelLarge: TextStyle(
          color: themes2[_currentThemeName]["primaryTextThemeColor"],
          fontSize: 26
        ),  
        labelMedium: TextStyle(
          color: themes2[_currentThemeName]["primaryTextThemeColor"],
          fontSize: 24
        ),
        labelSmall: TextStyle(
          color: themes2[_currentThemeName]["primaryTextThemeColor"],
          fontSize: 22
        ),       
      bodyLarge: TextStyle(
        color: themes2[_currentThemeName]["primaryTextThemeColor"],
        fontSize: 24
      ),
      bodyMedium: TextStyle(
        color: themes2[_currentThemeName]["primaryTextThemeColor"],
        fontSize: 18
      ),
      bodySmall: TextStyle(
        color: themes2[_currentThemeName]["primaryTextThemeColor"],
        fontSize: 14
      ),      

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: themes2[_currentThemeName]["elevatedButtonBackgroundColor"],
        foregroundColor: themes2[_currentThemeName]["elevatedButtonForegroundColor"],
      ),
    ),
  );
  ThemeData get currentTheme => _currentTheme;

  // void selectTheme(String theme) {
  //   _currentThemeName = theme;
  //   _currentTheme = themes[theme]??_redTheme;
  //   notifyListeners();
  // }




  

  void selectTheme2(String theme) {
    _currentTheme = ThemeData (
      colorScheme: ColorScheme.fromSeed(
        seedColor: themes2[theme]["seedColor"]
      ),
      dividerColor: themes2[theme]["dividerColor"],
      cardColor: themes2[theme]["cardColor"],
      cardTheme: CardThemeData(
        shadowColor: Colors.black,
        elevation: 7.0
      ),
      appBarTheme: AppBarTheme(
        color: themes2[theme]["appBarThemeColor"],
        foregroundColor: themes2[theme]["appBarTextColor"],
      ),
      scaffoldBackgroundColor: themes2[theme]["scaffoldBackgroundColor"],
      primaryTextTheme: TextTheme(
        labelLarge: TextStyle(
          color: themes2[theme]["primaryTextThemeColor"],
          fontSize: 28
        ),  
        labelMedium: TextStyle(
          color: themes2[theme]["primaryTextThemeColor"],
          fontSize: 28
        ),
        labelSmall: TextStyle(
          color: themes2[theme]["primaryTextThemeColor"],
          fontSize: 22
        ),                       
        bodyLarge: TextStyle(
          color: themes2[theme]["primaryTextThemeColor"],
          fontSize: 24
        ),
        bodyMedium: TextStyle(
          color: themes2[theme]["primaryTextThemeColor"],
          fontSize: 20
        ),
        bodySmall: TextStyle(
          color: themes2[theme]["primaryTextThemeColor"],
          fontSize: 16
        ), 
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themes2[theme]["elevatedButtonBackgroundColor"],
          foregroundColor: themes2[theme]["elevatedButtonForegroundColor"],
        ),
      ),
    );
    _currentThemeName = theme;
    notifyListeners();


  }

  




}