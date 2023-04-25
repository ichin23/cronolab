import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Updater {
  init(BuildContext context) async {
    double appVersion = 2.35;
    // await GetVersion.projectVersion;

    var response = await http.get(
        Uri.parse("https://ichin23.github.io/deveres/version.json"),
        headers: {
          "Content-Type": "application/json",
        });
    Map versionJson = jsonDecode(response.body);
    if (versionJson['version'] > appVersion) {
      // debugPrint("novaAtualização");
      var newFile = await http.get(Uri.parse(versionJson['url']));
      var apk = await File((await getApplicationDocumentsDirectory()).path +
              "newVersion.apk")
          .writeAsBytes(newFile.bodyBytes);
      //SnackBar update
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Column(
          children: [
            Text("Novidades no App"),
            Text("Deseja instalar uma nova atualização?"),
          ],
        ),

        margin: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
        duration: const Duration(seconds: 20),


        action: SnackBarAction(
          textColor:Colors.white,
          label:
            "SIM",

          onPressed: () {
            OpenFile.open(apk.path);
          },
        ),
      ));

      // debugPrint(newFile.body);
    }
    // debugPrint(versionJson);
  }
}
