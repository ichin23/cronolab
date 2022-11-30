import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/cronolab/desktop/index.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/cronolab/mobile/index.dart';
import 'package:cronolab/modules/dever/view/mobile/deverDetails.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/modules/turmas/view/mobile/editarTurma.dart';
import 'package:cronolab/modules/user/view/desktop/loginPage.dart';
import 'package:cronolab/modules/user/view/desktop/perfil.dart';
import 'package:cronolab/modules/user/view/mobile/loginPage.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/cronolab/mobile/controller/indexController.dart';
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

    Get.put(IndexController());
    Get.put(DeveresController());
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        Get.put(TurmasState());
        Get.put(TurmasLocal());
        TurmasLocal.to.init();
      } else {
        Get.put(TurmasStateDesktop());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      title: "Cronolab",
      theme: ThemeData(
          fontFamily: "Inter",
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            primary: primary2,
          ),
          scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              thickness: MaterialStateProperty.all(10),
              crossAxisMargin: 0,
              thumbColor: MaterialStateProperty.all(primary2),
              radius: const Radius.circular(10),
              minThumbLength: 100),
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
          page: () => StreamBuilder<bool>(
            stream: FirebaseAuth.instance.signInState.asBroadcastStream(),
            builder: (context, stream) {
              print(stream.data);
              print(stream.connectionState);
              if (stream.connectionState != ConnectionState.waiting) {
                if (stream.data != null) {
                  if (stream.data!) {
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
