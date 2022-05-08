import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/user/view/loginPage.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dever/view/deverTile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> frases = [
    "Deveres",
    "Pra que abrir SIGAA?",
    "Melhor que o gaTU",
    "Entrou no CEFET, se fudeu"
  ];
  void _incrementCounter() {
    if (_counter == 3) {
      _counter = 0;
    } else {
      _counter++;
    }
    setState(() {});
  }

  void refresh() {
    setState(() {});
  }

  DateFormat dateStr = DateFormat("dd/MM/yyyy");
  DateFormat hourStr = DateFormat("Hm");

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primary,
      systemNavigationBarColor: primary,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.black26)),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          backgroundColor: const Color(0xffB8DCFF),
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 70,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/perfil");
                },
                icon: const Icon(Icons.person, color: Colors.black26))
          ],
          title: GestureDetector(
              onDoubleTap: _incrementCounter,
              onTap: () {
                // print(turmas.turmaAtual!.isAdmin);
              },
              onLongPress: () async {},
              child: Text(
                frases[_counter],
                // (turmas.turmaAtual != null
                //     ? " - ${turmas.turmaAtual!.nome.toString()}"
                //     : ""),
                style: const TextStyle(color: Colors.black26),
              )),
        ),
        // SliverPadding(
        //   padding: const EdgeInsets.all(10),
        //   // sliver: SliverGrid(
        //   //     gridDelegate:
        //   //         const SliverGridDelegateWithFixedCrossAxisCount(
        //   //             childAspectRatio: 1 / 1.7,
        //   //             crossAxisCount: kIsWeb ? 5 : 2,
        //   //             crossAxisSpacing: 5,
        //   //             mainAxisSpacing: 5),
        //   //     delegate: SliverChildBuilderDelegate(
        //   //       (context, i) => DeverTile(list![i].data(),
        //   //           notifyParent: refresh),
        //   //       childCount: list!.length,
        //   //     )),
        // )
      ]),
    );
    // return Consumer(builder: (context, turmas, _) {
    //   if (turmas.turmaAtual != null) {
    //     return FutureBuilder<List<QueryDocumentSnapshot<Dever>>?>(
    //       future: turmas.turmaAtual!.getAtividades(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.done &&
    //             snapshot.hasData) {
    //           var list = snapshot.data;
    //           return Consumer<TurmasProvider>(
    //             builder: (context, turmas, _) =>
    //                 CustomScrollView(slivers: [
    //               SliverAppBar(
    //                 leading: IconButton(
    //                     onPressed: () {
    //                       widget.scaffoldKey.currentState!.openDrawer();
    //                     },
    //                     icon: const Icon(Icons.menu,
    //                         color: Colors.black26)),
    //                 shape: const RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.only(
    //                         bottomLeft: Radius.circular(10),
    //                         bottomRight: Radius.circular(10))),
    //                 backgroundColor: const Color(0xffB8DCFF),
    //                 elevation: 0,
    //                 centerTitle: true,
    //                 toolbarHeight: 70,
    //                 actions: [
    //                   IconButton(
    //                       onPressed: () {
    //                         Navigator.pushNamed(context, "/perfil");
    //                       },
    //                       icon: const Icon(Icons.person,
    //                           color: Colors.black26))
    //                 ],
    //                 title: GestureDetector(
    //                     onDoubleTap: _incrementCounter,
    //                     onTap: () {
    //                       print(turmas.turmaAtual!.isAdmin);
    //                     },
    //                     onLongPress: () async {},
    //                     child: Text(
    //                       frases[_counter] +
    //                           (turmas.turmaAtual != null
    //                               ? " - ${turmas.turmaAtual!.nome.toString()}"
    //                               : ""),
    //                       style: const TextStyle(color: Colors.black26),
    //                     )),
    //               ),
    //               SliverPadding(
    //                 padding: const EdgeInsets.all(10),
    //                 sliver: SliverGrid(
    //                     gridDelegate:
    //                         const SliverGridDelegateWithFixedCrossAxisCount(
    //                             childAspectRatio: 1 / 1.7,
    //                             crossAxisCount: kIsWeb ? 5 : 2,
    //                             crossAxisSpacing: 5,
    //                             mainAxisSpacing: 5),
    //                     delegate: SliverChildBuilderDelegate(
    //                       (context, i) => DeverTile(list![i].data(),
    //                           notifyParent: refresh),
    //                       childCount: list!.length,
    //                     )),
    //               )
    //             ]),
    //           );
    //         } else if (snapshot.hasError) {}
    //         return const Center(child: CircularProgressIndicator());
    //       },
    //     );
    //   } else {
    //     turmas.getTurmas();
    //     return Container();
    //   }
    // });
  }
}
