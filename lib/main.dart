import 'dart:io';

import 'package:cronolab/core/app.dart';
import 'package:cronolab/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'shared/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && !Platform.isLinux) {
    OneSignal.shared.setAppId("d9393c5e-61e9-4174-9d19-3d1e3eb7ad3f");
  }
  runApp(FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snap) {
        return snap.connectionState == ConnectionState.done
            ? const MainApp()
            : Container(
                color: black,
              );
      }));
}
