import 'package:cronolab/core/app.dart';
import 'package:cronolab/modules/di/injection.dart';
import 'package:cronolab/shared/models/settings.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();

  runApp(const MainApp());
}
