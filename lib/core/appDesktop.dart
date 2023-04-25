import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/cronolab/desktop/index.dart';
import 'package:cronolab/modules/cronolab/mobile/index.dart';
import 'package:cronolab/modules/dever/view/mobile/deverDetails.dart';
import 'package:cronolab/modules/turmas/view/mobile/editarTurma.dart';
import 'package:cronolab/modules/user/view/desktop/loginPage.dart';
import 'package:cronolab/modules/user/view/desktop/perfil.dart';
import 'package:cronolab/modules/user/view/mobile/loginPage.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../modules/turmas/view/mobile/gerenciarTurmas.dart';
import '../modules/user/view/mobile/perfil.dart';
import '../modules/user/view/mobile/suasInfos.dart';

class MainAppDesktop extends StatefulWidget {
  const MainAppDesktop({Key? key}) : super(key: key);

  @override
  State<MainAppDesktop> createState() => _MainAppDesktopState();
}

class _MainAppDesktopState extends State<MainAppDesktop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      title: "Cronolab",
      theme: ThemeData(
          fontFamily: "Inter",
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Theme.of(context).primaryColor,
            primary: Theme.of(context).primaryColor,
          ),
          scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              thickness: MaterialStateProperty.all(10),
              crossAxisMargin: 0,
              thumbColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
              radius: const Radius.circular(10),
              minThumbLength: 100),
          primaryColor: Theme.of(context).primaryColor,
          appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              centerTitle: true,
              toolbarHeight: 55,
              titleTextStyle: const TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
                  fontWeight: FontWeight.w800))
          //brightness: Brightness.light
          // primarySwatch: Colors.blue,
          // primarySwatch:  primary,
          ),
      initialRoute: "/",
      routes: {
        "/": (context) => StreamBuilder<bool>(
              stream: FirebaseAuth.instance.signInState.asBroadcastStream(),
              builder: (context, stream) {
                debugPrint(stream.data.toString());
                debugPrint(stream.connectionState.toString());
                if (stream.connectionState != ConnectionState.waiting) {
                  if (stream.data != null) {
                    if (stream.data!) {
                      return kIsWeb
                          ? const HomePageDesktop()
                          : Platform.isLinux || Platform.isWindows
                              ? const HomePageDesktop()
                              :
                              // FutureBuilder(
                              //     future:
                              //         Provider.of<TurmasLocal>(context).init(),
                              //     builder: (context, snap) {
                              //       return snap.connectionState ==
                              //               ConnectionState.done
                              //           ?
                              const HomeScreen();
                      //       : Container();
                      // });
                    } else {
                      return kIsWeb
                          ? const LoginPageDesktop()
                          : Platform.isLinux || Platform.isWindows
                              ? const LoginPageDesktop()
                              : const LoginPage();
                    }
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
        "/perfil": (context) => kIsWeb
            ? const PerfilPageDesktop()
            : Platform.isLinux || Platform.isWindows
                ? const PerfilPageDesktop()
                : const PerfilPage(),
        "/minhasTurmas": (context) => const GerenciarTurmas(),
        "/suasInfos": (context) => const SuasInformacoes(),
        "/turma": (context) => const EditarTurma(),
        // "/dever": (context) => const DeverDetails(),
      },
    );
  }
}
