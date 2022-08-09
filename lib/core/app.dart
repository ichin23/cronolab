import 'dart:io';

import 'package:cronolab/modules/cronolab/desktop/index.dart';
import 'package:cronolab/modules/cronolab/mobile/index.dart';
import 'package:cronolab/modules/dever/view/mobile/deverDetails.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/modules/turmas/view/mobile/editarTurma.dart';
import 'package:cronolab/modules/user/view/desktop/loginPage.dart';
import 'package:cronolab/modules/user/view/mobile/loginPage.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/turmas/view/mobile/gerenciarTurmas.dart';
import '../modules/user/view/mobile/perfil.dart';
import '../modules/user/view/mobile/suasInfos.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(TurmasState());
    Get.put(TurmasLocal());

    return GetMaterialApp(
      defaultTransition: Transition.rightToLeftWithFade,
      title: "Cronolab",
      theme: ThemeData(
          fontFamily: "Inter",
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            primary: primary2,
          ),
          primaryColor: primary2,
          appBarTheme: const AppBarTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              backgroundColor: primary2,
              elevation: 0,
              centerTitle: true,
              toolbarHeight: 70,
              titleTextStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 24,
                  fontWeight: FontWeight.w800))
          //brightness: Brightness.light
          // primarySwatch: Colors.blue,
          // primarySwatch:  primary,
          ),
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, stream) {
              if (stream.connectionState != ConnectionState.waiting) {
                if (stream.data != null) {
                  print(stream.data!.uid);
                  return Platform.isLinux || Platform.isWindows
                      ? const HomePageDesktop()
                      : const HomeScreen();
                } else {
                  return Platform.isLinux || Platform.isWindows
                      ? const LoginPageDesktop()
                      : const LoginPage();
                }
              } else {
                return Scaffold(
                  body: Center(child: Image.asset("assets/image/logo.png")),
                );
              }
            },
          ),
        ),
        GetPage(name: "/perfil", page: () => const PerfilPage()),
        GetPage(name: "/minhasTurmas", page: () => const GerenciarTurmas()),
        GetPage(name: "/suasInfos", page: () => const SuasInformacoes()),
        GetPage(name: "/turma", page: () => const EditarTurma()),
        GetPage(name: "/dever", page: () => const DeverDetails()),
      ],
    );
  }
}
