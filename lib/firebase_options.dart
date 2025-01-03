// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfxV0UhdKJxmWH2N2oa5V6x2YGw1SmhzI',
    appId: '1:1084933273366:android:b8595f3a5edd77c869c237',
    messagingSenderId: '1084933273366',
    projectId: 'starfolio-ff738',
    storageBucket: 'starfolio-ff738.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuoF052XBkrcU2HmbIFwRRTvEMTdTiyVg',
    appId: '1:1084933273366:ios:a0bb1ae3ece395ba69c237',
    messagingSenderId: '1084933273366',
    projectId: 'starfolio-ff738',
    storageBucket: 'starfolio-ff738.appspot.com',
    androidClientId: '1084933273366-7e7mshon99f9b571g8erl0u0u07bgufr.apps.googleusercontent.com',
    iosClientId: '1084933273366-jl29f2j2e4pjo0vadg8aqi619jagqj5k.apps.googleusercontent.com',
    iosBundleId: 'com.anishmalepati.starfolio',
  );
}
