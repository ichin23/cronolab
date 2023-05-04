import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/cronolab/desktop/index.dart';
import 'package:cronolab/modules/cronolab/mobile/index.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/dever/view/mobile/deverDetails.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/view/mobile/editarTurma.dart';
import 'package:cronolab/modules/user/view/desktop/loginPage.dart';
import 'package:cronolab/modules/user/view/desktop/perfil.dart';
import 'package:cronolab/modules/user/view/mobile/loginPage.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/models/cronolabExceptions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

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
  var loading = false;
  Future loadFromFirebase(Turmas turmas) async {
    //if(loading)return;
    loading=true;

    var internet = await InternetConnectionChecker().hasConnection;

    if (!internet) {
      return Future.error(CronolabException("Sem Internet", 100));
    }
    await turmas.turmasFB.loadTurmasUser(turmas.turmasSQL);
    await turmas.saveFBData();
    await turmas.getData();
    loading=false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Turmas()),
        // ChangeNotifierProxyProvider<TurmasFirebase, TurmasSQL>(
        //   create: (context) => TurmasSQL(),
        //   update: (_, firebase, sql) {
        //     sql?.checkNew(firebase);
        //     return sql ?? TurmasSQL();
        //   },
        // ),
        // ChangeNotifierProvider(create: (context) => TurmasState()),
        // ChangeNotifierProvider(create: (context) => IndexController()),
        // ChangeNotifierProvider(create: (context) => DeveresController()),
        // ChangeNotifierProvider(create: (context) => TurmasStateDesktop()),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        title: "Cronolab",
        theme: ThemeData(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            iconTheme: const IconThemeData(color: backgroundDark, size: 25),
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
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: backgroundDark,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: backgroundDark,
              titleTextStyle: labelDark,
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: backgroundDark,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20))),
            ),
            textTheme: const TextTheme(
              labelMedium: labelLight,
              labelLarge: inputDeverDark,
              bodyMedium: blackFont,
              headlineSmall: inputLight,
              //1
              headlineMedium: buttonTextDark,
              //2
              headlineLarge: labelPrimaryDark, //3
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: primaryLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
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
        //initialRoute: "/",
        onGenerateRoute: (settings) {
          var args = settings.arguments;

          switch (settings.name) {
            case "/":
              return MaterialPageRoute(
          builder: (context)=> StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, stream) {
                        if (stream.connectionState != ConnectionState.waiting) {
                          if (stream.data != null) {
                            return kIsWeb
                                ? const HomePageDesktop()
                                : Platform.isLinux || Platform.isWindows
                                    ? const HomePageDesktop()
                                    : Builder(builder: (context) {
                                        return FutureBuilder(
                                            future:  loadFromFirebase(
                                                context.read<Turmas>()),
                                            builder: (context, snap) {
                                              print(snap.error);
                                              return Stack(
                                                children: [
                                                  HomeScreen(),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: snap.connectionState ==
                                                              ConnectionState
                                                                  .waiting
                                                          ? Container(
                                                              width: 30,
                                                              height: 30,
                                                              child:
                                                                  CircularProgressIndicator())
                                                          : snap.hasError
                                                              ? Icon(
                                                                  Icons
                                                                      .signal_wifi_connected_no_internet_4_outlined,
                                                                  color: primaryDark
                                                                      .withOpacity(
                                                                          0.7),
                                                                )
                                                              : Container())
                                                ],
                                              );
                                            });
                                      });
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
                          return Scaffold(
                            body: Center(
                                child: Image.asset("assets/image/logo.png")),
                          );
                        }
                      },
                    ),
              );

            case "/perfil":
              return MaterialPageRoute(builder: (context)=> kIsWeb
                  ? const PerfilPageDesktop()
                  : Platform.isLinux || Platform.isWindows
                      ? const PerfilPageDesktop()
                      : const PerfilPage());
              break;
            case "/minhasTurmas":
              return  MaterialPageRoute(builder: (context)=> GerenciarTurmas());
              break;
            case "/suasInfos":
             return  MaterialPageRoute(builder: (context)=> SuasInformacoes());
              break;
            case "/turma":
              if(args is Turma)
              return MaterialPageRoute(builder: (context)=> EditarTurma(args));
              break;
            case "/dever":
              if(args is Map)
              return MaterialPageRoute(builder: (context)=> DeverDetails(args["dever"], args["index"]));
              break;
          }
        },
      ),
    );
  }
}
