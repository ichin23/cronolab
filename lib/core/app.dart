import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/cronolab/desktop/load.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/cronolab/mobile/index.dart';
import 'package:cronolab/modules/cronolab/mobile/testIndex.dart';
import 'package:cronolab/modules/dever/view/mobile/deverDetails.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/modules/turmas/view/mobile/editarTurma.dart';
import 'package:cronolab/modules/turmas/view/mobile/mudarTurma.dart';
import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/modules/user/view/desktop/perfil.dart';
import 'package:cronolab/modules/user/view/mobile/loginPageMobile.dart';

import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/models/settings.dart';
import 'package:cronolab/shared/screens/ajudaScreen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../modules/turmas/view/mobile/gerenciarTurmas.dart';
import '../modules/user/view/loginPage.dart';
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

  late UserProvider useProv;

  @override
  void initState() {
    super.initState();
    useProv = GetIt.instance<UserProvider>();
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  fontWeight: FontWeight.w800)),
          colorScheme: ColorScheme.fromSeed(
            secondary: secondaryDark,
            seedColor: secondaryDark,
            primary: primaryDark,
          ).copyWith(background: backgroundDark, error: redDark)),
      onGenerateRoute: (settings) {
        var args = settings.arguments;
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(
              builder: (context) => ValueListenableBuilder(
                  valueListenable: useProv.token,
                  builder: (context, token, _) {
                    if (token != null) {
                      return kIsWeb
                          ? Builder(
                              builder: (context) => const LoadDataDesktop())
                          : const HomePage();
                    } else {
                      return MediaQuery.of(context).size.width > 800
                          ? const LoginPage()
                          : const LoginPageMobile();
                    }
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
              return MaterialPageRoute(builder: (context) => EditarTurma(args));
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
            return MaterialPageRoute(builder: (context) => const AjudaScreen());
          case "/mudarTurma":
            return MaterialPageRoute(builder: (context) => const MudarTurma());
        }
        return null;
      },
    );
  }
}
