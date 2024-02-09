import 'package:flutter/material.dart';
import 'package:starfolio/utils/theme/custom_themes/appbar_theme.dart';
import 'package:starfolio/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:starfolio/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:starfolio/utils/theme/custom_themes/chip_theme.dart';
import 'package:starfolio/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:starfolio/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:starfolio/utils/theme/custom_themes/text_field_theme.dart';
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
    chipTheme: ChipTheme2.lightChipTheme,
    appBarTheme: AppBarTheme2.lightAppBarTheme,
    checkboxTheme: CheckboxTheme2.lightCheckboxTheme,
    outlinedButtonTheme: OutlinedButtonTheme2.lightOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme2.lightTextFormFieldTheme,
    bottomSheetTheme: BottomSheetTheme2.lightBottomSheetTheme
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme2.darkTextTheme,
      elevatedButtonTheme: ElevatedButtonTheme2.darkElevatedButtonTheme,
      chipTheme: ChipTheme2.darkChipTheme,
      appBarTheme: AppBarTheme2.darkAppBarTheme,
      checkboxTheme: CheckboxTheme2.darkCheckboxTheme,
      outlinedButtonTheme: OutlinedButtonTheme2.darkOutlinedButtonTheme,
      inputDecorationTheme: TextFormFieldTheme2.darkTextFormFieldTheme,
      bottomSheetTheme: BottomSheetTheme2.darkBottomSheetTheme
  );
}