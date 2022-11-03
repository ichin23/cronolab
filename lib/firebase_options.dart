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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCban6xMGmPa9vwKk653MZShmBvl7jYznU',
    appId: '1:286245196387:web:438113f5ee6ba4c560de56',
    messagingSenderId: '286245196387',
    projectId: 'deveres-faa4f',
    authDomain: 'deveres-faa4f.firebaseapp.com',
    storageBucket: 'deveres-faa4f.appspot.com',
    measurementId: 'G-7DESB1W6BQ',
  );

  static const FirebaseOptions windows = FirebaseOptions(
      apiKey: "AIzaSyCban6xMGmPa9vwKk653MZShmBvl7jYznU",
      appId: "1:286245196387:web:438113f5ee6ba4c560de56",
      messagingSenderId: "286245196387",
      projectId: "deveres-faa4f",
      storageBucket: "deveres-faa4f.appspot.com",
      authDomain: "deveres-faa4f.firebaseapp.com",
      measurementId: "G-7DESB1W6BQ");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADokojB6V778BvQvL5kFXcrKUFFobSArc',
    appId: '1:286245196387:android:d811660d7091134660de56',
    messagingSenderId: '286245196387',
    projectId: 'deveres-faa4f',
    storageBucket: 'deveres-faa4f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCW8aewNV-kw-tkV2NoYN2Ivr68DY4qqiU',
    appId: '1:286245196387:ios:c0dac02923068efa60de56',
    messagingSenderId: '286245196387',
    projectId: 'deveres-faa4f',
    storageBucket: 'deveres-faa4f.appspot.com',
    androidClientId:
        '286245196387-5rkfvp73eq0gjtlor5b2k2ve59tk1agn.apps.googleusercontent.com',
    iosClientId:
        '286245196387-02fdnsk01sn42lf0onnanfvgvk1armgu.apps.googleusercontent.com',
    iosBundleId: 'com.cronolab.cronolab',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCW8aewNV-kw-tkV2NoYN2Ivr68DY4qqiU',
    appId: '1:286245196387:ios:c0dac02923068efa60de56',
    messagingSenderId: '286245196387',
    projectId: 'deveres-faa4f',
    storageBucket: 'deveres-faa4f.appspot.com',
    androidClientId:
        '286245196387-5rkfvp73eq0gjtlor5b2k2ve59tk1agn.apps.googleusercontent.com',
    iosClientId:
        '286245196387-02fdnsk01sn42lf0onnanfvgvk1armgu.apps.googleusercontent.com',
    iosBundleId: 'com.cronolab.cronolab',
  );
}
