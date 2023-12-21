import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  Map settings = {};
  late int limTurmas;
  late int limMaterias;
  late double minVersion;

  Settings() {
    getSettings();
  }

  Future getSettings() async {
    if (settings.isNotEmpty) return;
    /*var sett = await FirebaseFirestore.instance.collection("settings").get();
    for (var element in sett.docs) {
      settings[element.id] = element.data();
    }
    limTurmas = settings["turmas"]["quantTurmas"] ?? 3;
    limMaterias = settings["turmas"]["quantMaterias"] ?? 10;
    minVersion = settings["app"]["version"] ?? 3.01;*/
  }
}
