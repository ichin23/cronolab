import 'package:cronolab/modules/cronolab/desktop/widgets/calendar.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deverTile.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  late TapDownDetails details;
  late Future turmasFuture;
  var key = GlobalKey<CalendarState>();
  @override
  void initState() {
    super.initState();
    TurmasState.to.getTurmas();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: GetBuilder<TurmasState>(builder: (turmas) {
            return Text(
              "Cronolab" +
                  (turmas.turmaAtual != null
                      ? " - ${turmas.turmaAtual!.nome}"
                      : ""),
              style: const TextStyle(fontSize: 20),
            );
          }),
          centerTitle: true,
          leading: GetBuilder<TurmasState>(builder: (turmas) {
            return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  var val = await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          size.width - details.globalPosition.dx,
                          size.height - details.globalPosition.dy),
                      color: black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      constraints: const BoxConstraints(minWidth: 100),
                      items: [
                        PopupMenuItem(
                            value: "perfil",
                            onTap: () {},
                            child:
                                const Text("Minha conta", style: fonts.white)),
                        PopupMenuItem(child:
                            GetBuilder<DeveresController>(builder: (deveres) {
                          return MouseRegion(
                            onHover: (ev) async {
                              var val = await showMenu(
                                  color: black,
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                      ev.position.dx,
                                      ev.position.dy,
                                      size.width - ev.position.dx,
                                      size.height - ev.position.dy),
                                  items: turmas.turmas
                                      .map((e) => PopupMenuItem<Turma>(
                                            value: e,
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.text,
                                              child: InkWell(
                                                  onTap: () {
                                                    turmas.changeTurmaAtual(e);

                                                    deveres.buildCalendar(
                                                        DateTime.now());
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: e.id ==
                                                              turmas.turmaAtual!
                                                                  .id
                                                          ? pretoClaro
                                                          : black,
                                                    ),
                                                    child: Text(
                                                      e.nome,
                                                      style: fonts.input,
                                                    ),
                                                  )),
                                            ),
                                          ))
                                      .toList());
                              if (val is Turma) {
                                turmas.changeTurmaAtual(val);

                                deveres.buildCalendar(DateTime.now());
                              }
                              Get.back();
                            },
                            child: Row(
                              children: const [
                                Text("Minhas turmas", style: fonts.white),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: white,
                                )
                              ],
                            ),
                          );
                        }))
                      ]);
                  if (val == "perfil") {
                    Get.toNamed("/perfil");
                  }
                },
                onTapDown: (tap) {
                  details = tap;
                },
                child: const Icon(
                  Icons.menu,
                  color: Colors.black45,
                ));
          }),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
        ),
        backgroundColor: black,
        body: GetBuilder<TurmasState>(builder: (turmas) {
          return turmas.loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        width: size.width * 0.35,
                        child:
                            GetBuilder<DeveresController>(builder: (deveres) {
                          return Scrollbar(
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                padding: const EdgeInsets.only(right: 15),
                                itemCount: deveres.diaAtual != null
                                    ? deveres.diaAtual!.deveres.length
                                    : turmas.turmaAtual!.deveres!.length,
                                itemBuilder: (context, i) => DeverTile(
                                        deveres.diaAtual != null
                                            ? deveres.diaAtual!.deveres[i]
                                            : turmas.turmaAtual!.deveres![i],
                                        notifyParent: () {
                                      setState(() {});
                                    })),
                          );
                        })
                        // child: Column(
                        //   children: [
                        //     Expanded(
                        //       child: ListView(
                        //           children: turmas.turmas
                        //               .map((e) => MouseRegion(
                        //                     cursor: SystemMouseCursors.text,
                        //                     child: ListTile(
                        //                       onTap: () {
                        //                         turmas.changeTurmaAtual(e);

                        //                         key.currentState!
                        //                             .buildCalendar(DateTime.now());
                        //                         setState(() {});
                        //                       },
                        //                       shape: RoundedRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius.circular(10)),
                        //                       tileColor:
                        //                           e.id == turmas.turmaAtual!.id
                        //                               ? pretoClaro
                        //                               : black,
                        //                       title: Text(
                        //                         e.nome,
                        //                         style: fonts.input,
                        //                       ),
                        //                     ),
                        //                   ))
                        //               .toList()),
                        //     ),
                        //     MouseRegion(
                        //       cursor: SystemMouseCursors.click,
                        //       child: Container(
                        //         padding: const EdgeInsets.all(5),
                        //         margin: const EdgeInsets.all(8),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: pretoClaro,
                        //         ),
                        //         child: InkWell(
                        //           onTap: () {
                        //             Get.toNamed("/perfil");
                        //           },
                        //           child: Row(children: [
                        //             FirebaseAuth.instance.currentUser!.photoURL !=
                        //                     null
                        //                 ? Image.network(FirebaseAuth
                        //                     .instance.currentUser!.photoURL!)
                        //                 : Container(
                        //                     width: size.width * 0.05,
                        //                     height: size.width * 0.05,
                        //                     decoration: BoxDecoration(
                        //                         color: black,
                        //                         borderRadius:
                        //                             BorderRadius.circular(10)),
                        //                     child: const Icon(
                        //                       Icons.person,
                        //                       size: 40,
                        //                       color: white,
                        //                     )),
                        //             const SizedBox(width: 10),
                        //             Column(
                        //               mainAxisSize: MainAxisSize.max,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   FirebaseAuth
                        //                       .instance.currentUser!.displayName
                        //                       .toString(),
                        //                   style: fonts.label,
                        //                 ),
                        //                 TextButton(
                        //                     onPressed: () {
                        //                       FirebaseAuth.instance.signOut();
                        //                     },
                        //                     child: const Text("Sair"))
                        //               ],
                        //             ),
                        //           ]),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        ),
                    Calendar(
                      size.width * 0.62,
                      size.height * 0.95 - 50,
                      key: key,
                    )
                  ],
                );
        }));
  }
}
