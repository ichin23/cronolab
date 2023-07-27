import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  Map settings = {};

  Future getSettings() async {
    if (settings.isNotEmpty) return;
    var sett = await FirebaseFirestore.instance.collection("settings").get();
    for (var element in sett.docs) {
      settings[element.id] = element.data();
    }
  }
}
