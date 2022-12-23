import 'dart:io';

import 'package:cronolab/core/app.dart';
import 'package:cronolab/firebase_options.dart';
import 'package:cronolab/shared/models/sharedStore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:window_size/window_size.dart';

import 'core/appDesktop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      OneSignal.shared.setAppId("d9393c5e-61e9-4174-9d19-3d1e3eb7ad3f");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    if (Platform.isLinux || Platform.isWindows) {
      //setWindowTitle('Cronolab');
      setWindowMinSize(const Size(1100, 500));
      setWindowMaxSize(Size.infinite);
      Firestore.initialize(DefaultFirebaseOptions.windows.projectId,
          databaseId: DefaultFirebaseOptions.windows.databaseURL);
      await SharedStore.init();
      FirebaseAuth.initialize(
          DefaultFirebaseOptions.windows.apiKey, VolatileStore());
    }
  }
  runApp(Platform.isWindows ? const MainAppDesktop() : const MainApp());
}
