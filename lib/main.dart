import 'dart:io';

import 'package:cronolab/core/app.dart';
import 'package:cronolab/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  debugPrint(Platform.operatingSystem);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OneSignal.shared.setAppId("d9393c5e-61e9-4174-9d19-3d1e3eb7ad3f");
  runApp(const MainApp());
}
