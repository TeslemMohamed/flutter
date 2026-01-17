// FILE: lib/firebase_options.dart
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAvv0MxLx7pDyjQP_pLciZPgSWhdTCiIbs',
    appId: '1:120547961610:web:your_web_app_id', // تحتاج web app ID
    messagingSenderId: '120547961610',
    projectId: 'mahadre-app',
    authDomain: 'mahadre-app.firebaseapp.com',
    storageBucket: 'mahadre-app.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvv0MxLx7pDyjQP_pLciZPgSWhdTCiIbs',
    appId: '1:120547961610:android:4d149d1e06d1c74f74a8f3',
    messagingSenderId: '120547961610',
    projectId: 'mahadre-app',
    storageBucket: 'mahadre-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvv0MxLx7pDyjQP_pLciZPgSWhdTCiIbs',
    appId: '1:120547961610:ios:your_ios_app_id', // تحتاج iOS app ID
    messagingSenderId: '120547961610',
    projectId: 'mahadre-app',
    storageBucket: 'mahadre-app.firebasestorage.app',
    iosClientId: 'com.googleusercontent.apps.120547961610-xxxxxxxx',
    iosBundleId: 'com.example.mahadre',
  );
}