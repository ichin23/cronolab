import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Updater {
  void init(BuildContext context) async {
    double appVersion = 2.11;
    // await GetVersion.projectVersion;

    var response = await http.get(
        Uri.parse("https://ichin23.github.io/deveres/version.json"),
        headers: {
          "Content-Type": "application/json",
        });
    Map versionJson = jsonDecode(response.body);
    if (versionJson['version'] > appVersion) {
      // print("novaAtualização");
      var newFile = await http.get(Uri.parse(versionJson['url']));
      var apk = await File((await getApplicationDocumentsDirectory()).path +
              "newVersion.apk")
          .writeAsBytes(newFile.bodyBytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Deseja instalar uma nova atualização?",
          style: TextStyle(color: Color(0xff689687)),
        ),
        backgroundColor: const Color(0xffBDF6E3),
        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
        // padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
        duration: const Duration(minutes: 20),
        action: SnackBarAction(
          label: "SIM",
          textColor: const Color(0xff689687),
          onPressed: () {
            OpenFile.open(apk.path);
          },
        ),
      ));

      // print(newFile.body);
    }
    // print(versionJson);
  }
}
