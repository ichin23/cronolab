import 'package:cronolab/modules/cronolab/desktop/widgets/calendar.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  late Future turmasFuture;
  var key = GlobalKey<CalendarState>();
  @override
  void initState() {
    super.initState();
    turmasFuture = TurmasState.to.getTurmas();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: black,
      body: GetBuilder<TurmasState>(
          builder: (turmas) => turmas.loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: size.width * 0.17,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.84,
                            child: ListView(
                                children: turmas.turmas
                                    .map((e) => MouseRegion(
                                          cursor: SystemMouseCursors.text,
                                          child: ListTile(
                                            onTap: () {
                                              turmas.changeTurmaAtual(e);

                                              // key.currentState!.buildCalendar(
                                              //     DateTime.now());
                                              setState(() {});
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            tileColor:
                                                e.id == turmas.turmaAtual!.id
                                                    ? pretoClaro
                                                    : black,
                                            title: Text(
                                              e.nome,
                                              style: fonts.input,
                                            ),
                                          ),
                                        ))
                                    .toList()),
                          ),
                          Expanded(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: pretoClaro,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed("/perfil");
                                  },
                                  child: Row(children: [
                                    FirebaseAuth.instance.currentUser!
                                                .photoURL !=
                                            null
                                        ? Image.network(FirebaseAuth
                                            .instance.currentUser!.photoURL!)
                                        : Container(
                                            width: size.width * 0.05,
                                            height: size.width * 0.05,
                                            decoration: BoxDecoration(
                                                color: black,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Icon(
                                              Icons.person,
                                              size: 40,
                                              color: white,
                                            )),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          FirebaseAuth
                                              .instance.currentUser!.displayName
                                              .toString(),
                                          style: fonts.label,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              FirebaseAuth.instance.signOut();
                                            },
                                            child: const Text("Sair"))
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Calendar(
                      size.width * 0.8,
                      size.height * 0.95,
                      key: key,
                    )
                  ],
                )),
    );
  }
}
