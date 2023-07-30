import 'package:cronolab/core/app.dart';
import 'package:cronolab/firebase_options.dart';
import 'package:cronolab/shared/models/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Settings settings = Settings();
  try {
    await settings.getSettings();
  } catch (e) {
    debugPrint(e.toString());
  }

  runApp(MainApp(settings));
}
