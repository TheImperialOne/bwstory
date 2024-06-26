// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDOcl0yfMuE30l_kFCCLZKG5mtaWDoWMBM',
    appId: '1:100332376572:web:6ce633152a17d91ee02279',
    messagingSenderId: '100332376572',
    projectId: 'bwstory',
    authDomain: 'bwstory.firebaseapp.com',
    storageBucket: 'bwstory.appspot.com',
    measurementId: 'G-T1V8CV3XMY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4eLyUTtV6GwB8TiECKhG0LjsOAJm8fks',
    appId: '1:100332376572:android:c077581acf750090e02279',
    messagingSenderId: '100332376572',
    projectId: 'bwstory',
    storageBucket: 'bwstory.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAf7c0jEKrbdANoMy8oK2oUL6K0DCGFPuY',
    appId: '1:100332376572:ios:a307dbf220394cdce02279',
    messagingSenderId: '100332376572',
    projectId: 'bwstory',
    storageBucket: 'bwstory.appspot.com',
    iosBundleId: 'com.example.bwstory',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAf7c0jEKrbdANoMy8oK2oUL6K0DCGFPuY',
    appId: '1:100332376572:ios:a307dbf220394cdce02279',
    messagingSenderId: '100332376572',
    projectId: 'bwstory',
    storageBucket: 'bwstory.appspot.com',
    iosBundleId: 'com.example.bwstory',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDOcl0yfMuE30l_kFCCLZKG5mtaWDoWMBM',
    appId: '1:100332376572:web:9327693a5d41f5bbe02279',
    messagingSenderId: '100332376572',
    projectId: 'bwstory',
    authDomain: 'bwstory.firebaseapp.com',
    storageBucket: 'bwstory.appspot.com',
    measurementId: 'G-2FRQSVHQ5R',
  );
}
