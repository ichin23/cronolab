import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../shared/colors.dart';

class Updater {
  init() async {
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
      Get.snackbar(
        "Novidades no App",
        "Deseja instalar uma nova atualização?",
        margin: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
        duration: const Duration(seconds: 20),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        mainButton: TextButton(
          style: TextButton.styleFrom(backgroundColor: primary2),
          child: const Text(
            "SIM",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            OpenFile.open(apk.path);
          },
        ),
      );

      // print(newFile.body);
    }
    // print(versionJson);
  }
}
