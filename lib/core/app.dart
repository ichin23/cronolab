import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/cronolab/desktop/index.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/cronolab/mobile/index.dart';
import 'package:cronolab/modules/dever/view/mobile/deverDetails.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/modules/turmas/view/mobile/editarTurma.dart';
import 'package:cronolab/modules/user/view/desktop/loginPage.dart';
import 'package:cronolab/modules/user/view/desktop/perfil.dart';
import 'package:cronolab/modules/user/view/mobile/loginPage.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/cronolab/mobile/controller/indexController.dart';
import '../modules/turmas/view/mobile/gerenciarTurmas.dart';
import '../modules/user/view/mobile/perfil.dart';
import '../modules/user/view/mobile/suasInfos.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    Get.put(TurmasState());
    Get.put(IndexController());
    Get.put(DeveresController());
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        Get.put(TurmasLocal());
        TurmasLocal.to.init();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      defaultTransition: kIsWeb
          ? Transition.native
          : Platform.isLinux || Platform.isWindows
              ? Transition.fadeIn
              : Transition.rightToLeftWithFade,
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
              backgroundColor: primary2,
              elevation: 0,
              centerTitle: true,
              toolbarHeight: 55,
              titleTextStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
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
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, stream) {
              if (stream.connectionState != ConnectionState.waiting) {
                if (stream.data != null) {
                  return kIsWeb
                      ? const HomePageDesktop()
                      : Platform.isLinux || Platform.isWindows
                          ? const HomePageDesktop()
                          : FutureBuilder(
                              future: TurmasLocal.to.init(),
                              builder: (context, snap) {
                                return snap.connectionState ==
                                        ConnectionState.done
                                    ? const HomeScreen()
                                    : Container();
                              });
                } else {
                  return kIsWeb
                      ? const LoginPageDesktop()
                      : Platform.isLinux || Platform.isWindows
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
        GetPage(
            name: "/perfil",
            page: () => kIsWeb
                ? const PerfilPageDesktop()
                : Platform.isLinux || Platform.isWindows
                    ? const PerfilPageDesktop()
                    : const PerfilPage()),
        GetPage(name: "/minhasTurmas", page: () => const GerenciarTurmas()),
        GetPage(name: "/suasInfos", page: () => const SuasInformacoes()),
        GetPage(name: "/turma", page: () => const EditarTurma()),
        GetPage(name: "/dever", page: () => const DeverDetails()),
      ],
    );
  }
}
