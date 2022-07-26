import 'package:cronolab/modules/cronolab/pages/index.dart';
import 'package:cronolab/modules/dever/view/deverDetails.dart';
import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/modules/turmas/view/editarTurma.dart';
import 'package:cronolab/modules/user/view/loginPage.dart';

import 'package:cronolab/modules/user/view/perfil.dart';
import 'package:cronolab/modules/user/view/suasInfos.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/turmas/view/gerenciarTurmas.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(TurmasState());

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
          page: () => StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, stream) {
              if (stream.connectionState != ConnectionState.waiting) {
                if (stream.data != null) {
                  return const HomeScreen();
                } else {
                  return const LoginPage();
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
