import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:starfolio/app.dart';
import 'package:starfolio/firebase_options.dart';

import 'data/repositories/authentication/authentication_repository.dart';
import 'features/personalization/controllers/user_controller.dart';

// Entry point of Flutter app
Future<void> main() async {

  // Widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Local Storage
  await GetStorage.init();

  // Await Splash Screen Until Other Items Load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Await FIREBASE
  await Firebase.initializeApp (options: DefaultFirebaseOptions.currentPlatform).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository()),)
  ;

  Get.put(UserController());
  runApp(const App());
}
