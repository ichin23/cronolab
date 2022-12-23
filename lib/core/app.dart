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
import 'package:cronolab/shared/appTheme.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/cronolab/mobile/controller/indexController.dart';
import '../modules/turmas/view/mobile/gerenciarTurmas.dart';
import '../modules/user/view/mobile/perfil.dart';
import '../modules/user/view/mobile/suasInfos.dart';
import '../shared/fonts.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    Get.put(IndexController());
    Get.put(DeveresController());
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        Get.put(TurmasState());
        Get.put(TurmasLocal());
        Get.put(AppTheme());
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
      defaultTransition: kIsWeb
          ? Transition.native
          : Platform.isLinux || Platform.isWindows
              ? Transition.fadeIn
              : Transition.rightToLeftWithFade,
      title: "Cronolab",
      theme: ThemeData(
          fontFamily: "Inter",
          backgroundColor: backgroundLight,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: secondaryLight,
              primary: primaryLight,
              secondary: darkPrimary),
          scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              thickness: MaterialStateProperty.all(10),
              crossAxisMargin: 0,
              thumbColor: MaterialStateProperty.all(primaryLight),
              radius: const Radius.circular(10),
              minThumbLength: 100),
          primaryColor: primaryLight,
          errorColor: redLight,
          buttonTheme: ButtonThemeData(
              splashColor: darkPrimary,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          iconTheme: IconThemeData(color: backgroundLight, size: 25),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: whiteColor.withOpacity(0.1),
            labelStyle: labelLight,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          scaffoldBackgroundColor: backgroundLight,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: backgroundDark,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
          ),
          dialogTheme: DialogTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: backgroundLight,
            titleTextStyle: labelLight,
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: backgroundLight,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20))),
          ),
          textTheme: TextTheme(
            labelMedium: labelLight,
            labelLarge: inputDeverDark,
            bodyMedium: blackFont,
            headlineSmall: inputLight,
            headlineMedium: buttonTextDark,
            headlineLarge: labelPrimaryDark,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: primaryLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          hoverColor: hoverDark,
          appBarTheme: const AppBarTheme(
              backgroundColor: primaryLight,
              elevation: 0,
              centerTitle: true,
              toolbarHeight: 55,
              titleTextStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
                  fontWeight: FontWeight.w800))),
      darkTheme: ThemeData(
          fontFamily: "Inter",
          backgroundColor: backgroundDark,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: secondaryDark,
            primary: primaryDark,
          ),
          scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              thickness: MaterialStateProperty.all(10),
              crossAxisMargin: 0,
              thumbColor: MaterialStateProperty.all(primaryDark),
              radius: const Radius.circular(10),
              minThumbLength: 100),
          primaryColor: primaryDark,
          errorColor: redDark,
          buttonTheme: ButtonThemeData(
              splashColor: darkPrimary,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          iconTheme: IconThemeData(color: backgroundDark, size: 25),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: whiteColor.withOpacity(0.1),
            labelStyle: labelDark,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          scaffoldBackgroundColor: backgroundDark,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: backgroundDark,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
          ),
          dialogTheme: DialogTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: backgroundDark,
            titleTextStyle: labelDark,
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: backgroundDark,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20))),
          ),
          textTheme: TextTheme(
            labelMedium: labelLight,
            labelLarge: inputDeverDark,
            bodyMedium: blackFont,
            headlineSmall: inputLight, //1
            headlineMedium: buttonTextDark, //2
            headlineLarge: labelPrimaryDark, //3
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: primaryLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          hoverColor: hoverDark,
          appBarTheme: const AppBarTheme(
              backgroundColor: primaryDark,
              elevation: 0,
              centerTitle: true,
              toolbarHeight: 55,
              titleTextStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
                  fontWeight: FontWeight.w800))),
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
