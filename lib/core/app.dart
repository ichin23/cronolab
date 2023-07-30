import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/cronolab/desktop/load.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/cronolab/mobile/index.dart';
import 'package:cronolab/modules/dever/view/mobile/deverDetails.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/modules/turmas/view/mobile/editarTurma.dart';
import 'package:cronolab/modules/turmas/view/mobile/mudarTurma.dart';
import 'package:cronolab/modules/user/view/desktop/perfil.dart';
import 'package:cronolab/modules/user/view/mobile/loginPage.dart';

import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/models/settings.dart';
import 'package:cronolab/shared/screens/ajudaScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../modules/turmas/view/mobile/gerenciarTurmas.dart';
import '../modules/user/view/loginPage.dart';
import '../modules/user/view/mobile/perfil.dart';
import '../modules/user/view/mobile/suasInfos.dart';
import '../shared/fonts.dart';

class MainApp extends StatefulWidget {
  const MainApp(this.settings, {Key? key}) : super(key: key);
  final Settings settings;
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var loading = false;
  List<SingleChildWidget> providers = [];

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logAppOpen();

    providers = kIsWeb
        ? [
            ChangeNotifierProvider(create: (context) => widget.settings),
            ChangeNotifierProvider(create: (context) => DeveresController()),
            ChangeNotifierProvider(create: (context) => TurmasStateDesktop())
          ]
        : [
            ChangeNotifierProvider(create: (context) => widget.settings),
            ChangeNotifierProvider(create: (context) => Turmas())
          ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        title: "Cronolab",
        theme: ThemeData(
            fontFamily: "Inter",
            useMaterial3: true,
            scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: MaterialStateProperty.all(true),
                thickness: MaterialStateProperty.all(10),
                crossAxisMargin: 0,
                thumbColor: MaterialStateProperty.all(primaryDark),
                radius: const Radius.circular(10),
                minThumbLength: 100),
            primaryColor: primaryDark,
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
                    fontWeight: FontWeight.w800)),
            colorScheme: ColorScheme.fromSeed(
              secondary: secondaryDark,
              seedColor: secondaryDark,
              primary: primaryDark,
            ).copyWith(background: backgroundDark).copyWith(error: redDark)),
        onGenerateRoute: (settings) {
          var args = settings.arguments;
          FirebaseAnalytics.instance.logScreenView(screenName: settings.name);
          switch (settings.name) {
            case "/":
              return MaterialPageRoute(
                builder: (context) => FutureBuilder(
                    future: context.read<Settings>().getSettings(),
                    builder: (context, sett) {
                      return StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, stream) {
                          if (stream.connectionState !=
                              ConnectionState.waiting) {
                            if (stream.data != null) {
                              return kIsWeb
                                  ? Builder(
                                      builder: (context) =>
                                          const LoadDataDesktop())
                                  : Builder(builder: (context) {
                                      return const HomeScreen();
                                    });
                            } else {
                              return MediaQuery.of(context).size.width > 800
                                  ? const LoginPage()
                                  : const LoginPageMobile();
                            }
                          } else {
                            return Scaffold(
                              body: Center(
                                  child: Image.asset(
                                "assets/image/foreground.png",
                                width: MediaQuery.of(context).size.width * 0.4,
                              )),
                            );
                          }
                        },
                      );
                    }),
              );

            case "/perfil":
              return MaterialPageRoute(
                  builder: (context) => MediaQuery.of(context).size.width > 800
                      ? const PerfilPageDesktop()
                      : const PerfilPage());

            case "/minhasTurmas":
              return MaterialPageRoute(
                  builder: (context) => const GerenciarTurmas());

            case "/suasInfos":
              return MaterialPageRoute(
                  builder: (context) => const SuasInformacoes());

            case "/turma":
              if (args is Turma) {
                return MaterialPageRoute(
                    builder: (context) => EditarTurma(args));
              }
              break;
            case "/dever":
              if (args is Map) {
                return MaterialPageRoute(
                    builder: (context) =>
                        DeverDetails(args["dever"], args["index"]));
              }
              break;
            case "/ajuda":
              return MaterialPageRoute(
                  builder: (context) => const AjudaScreen());
              break;
            case "/mudarTurma":
              return MaterialPageRoute(
                  builder: (context) => const MudarTurma());
          }
          return null;
        },
      ),
    );
  }
}
