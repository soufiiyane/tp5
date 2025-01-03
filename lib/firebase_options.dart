// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// 
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBILXJmninqEubu9bi2wKITMUjPIiOY1Ho',
    appId: '1:29217661806:web:b8b28befc9bfdd1881d77f',
    messagingSenderId: '29217661806',
    projectId: 'atelier4-p-kasside-iir5gx',
    authDomain: 'atelier4-p-kasside-iir5gx.firebaseapp.com',
    storageBucket: 'atelier4-p-kasside-iir5gx.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSL2mC8_AFEuNvq1cEfnV0jE7hqQ6GYAU',
    appId: '1:29217661806:android:5f1bcf2aa76c823281d77f',
    messagingSenderId: '29217661806',
    projectId: 'atelier4-p-kasside-iir5gx',
    storageBucket: 'atelier4-p-kasside-iir5gx.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTTc7NJG4YrikvIlt8QRDN-cZD9phfxMA',
    appId: '1:29217661806:ios:1feeb4b5b40c655c81d77f',
    messagingSenderId: '29217661806',
    projectId: 'atelier4-p-kasside-iir5gx',
    storageBucket: 'atelier4-p-kasside-iir5gx.firebasestorage.app',
    iosBundleId: 'com.example.atelier4Firebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTTc7NJG4YrikvIlt8QRDN-cZD9phfxMA',
    appId: '1:29217661806:ios:1feeb4b5b40c655c81d77f',
    messagingSenderId: '29217661806',
    projectId: 'atelier4-p-kasside-iir5gx',
    storageBucket: 'atelier4-p-kasside-iir5gx.firebasestorage.app',
    iosBundleId: 'com.example.atelier4Firebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBILXJmninqEubu9bi2wKITMUjPIiOY1Ho',
    appId: '1:29217661806:web:cf78194e716a724981d77f',
    messagingSenderId: '29217661806',
    projectId: 'atelier4-p-kasside-iir5gx',
    authDomain: 'atelier4-p-kasside-iir5gx.firebaseapp.com',
    storageBucket: 'atelier4-p-kasside-iir5gx.firebasestorage.app',
  );

}