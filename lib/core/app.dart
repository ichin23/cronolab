import 'package:cronolab/modules/cronolab/pages/index.dart';
import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/modules/turmas/view/editarTurma.dart';
import 'package:cronolab/modules/user/view/loginPage.dart';
import 'package:cronolab/modules/user/view/perfil.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/turmas/turma.dart';
import '../modules/turmas/view/gerenciarTurmas.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TurmasProvider())
      ],
      child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              primary: primary,
            ),
            primaryColor: primary,
            // primarySwatch: Colors.blue,
            // primarySwatch:  primary,
          ),
          onGenerateRoute: (RouteSettings routeSettings) {
            switch (routeSettings.name) {
              // case "/":
              //   return MaterialPageRoute(builder: (context) => HomePage());
              case "/perfil":
                return MaterialPageRoute(builder: (context) => PerfilPage());
              case "/minhasTurmas":
                return MaterialPageRoute(
                    builder: (context) => GerenciarTurmas());
              case '/turma':
                var arg = routeSettings.arguments as Turma;
                return MaterialPageRoute(
                    builder: (context) => EditarTurma(
                          turma: arg,
                        ));
              // default:
              //   return MaterialPageRoute(builder: (context) => MyHomePage());
            }
          },
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, stream) {
                if (stream.connectionState != ConnectionState.waiting) {
                  if (stream.data != null) {
                    return HomeScreen();
                  } else {
                    return LoginPage();
                  }
                } else {
                  return Scaffold(
                    body: Center(child: Image.asset("assets/image/logo.png")),
                  );
                }
              })),
    );
  }
}
