import 'package:flutter/material.dart';
import 'package:starfolio/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:starfolio/utils/theme/custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme2.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonTheme2.lightElevatedButtonTheme,
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme2.darkTextTheme,
      elevatedButtonTheme: ElevatedButtonTheme2.darkElevatedButtonTheme,
  );
}