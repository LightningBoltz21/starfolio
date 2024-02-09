import 'package:flutter/material.dart';
import 'package:starfolio/bindings/general_bindings.dart';
import 'package:starfolio/utils/constants/colors.dart';
import 'package:starfolio/utils/theme/theme.dart';
import 'package:starfolio/features/authentication/screens/onboarding/onboarding.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      // Show Loader
      home: const Scaffold(backgroundColor: TColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white))),
    );
  }
}