import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/view/desktop/novaTurma.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:cronolab/shared/models/cronolabExceptions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppBarDesktop extends StatefulWidget {
  const AppBarDesktop({Key? key}) : super(key: key);

  @override
  State<AppBarDesktop> createState() => _AppBarDesktopState();
}

class _AppBarDesktopState extends State<AppBarDesktop> {
  late TurmasServer turmas;
  late DeveresController deveres;

  @override
  void initState() {
    turmas = GetIt.I.get<TurmasServer>();
    deveres = GetIt.I.get<DeveresController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ValueListenableBuilder<Turma?>(
            valueListenable: turmas.turmaAtual,
            builder: (context, turmaAtual, _) {
              return Container(
                  decoration: const BoxDecoration(
                      color: backgroundDark,
                      border: Border(
                          bottom: BorderSide(color: primaryDark, width: 3))),
                  //padding: const EdgeInsets.all(8),
                  width: size.width,
                  height: 46,
                  child: size.width > 800
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () async {
                                  turmas.changeTurma(null);
                                  deveres.buildCalendar(
                                      DateTime.now(), context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5)),
                                        color: turmaAtual == null
                                            ? primaryDark
                                            : Colors.transparent),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      "Cronolab",
                                      style: TextStyle(
                                          color: turmaAtual == null
                                              ? backgroundDark
                                              : primaryDark),
                                    ))),
                            Expanded(
                                child: ValueListenableBuilder<List<Turma>>(
                              builder: (context, turmasList, _) {
                                return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...turmasList
                                          .map(
                                            (e) => Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              child: MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await turmas.changeTurma(e);
                                                    await deveres.buildCalendar(
                                                        DateTime.now(),
                                                        context);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              topRight: Radius
                                                                  .circular(5),
                                                              bottomLeft: Radius
                                                                  .circular(0)),
                                                      color: e.id ==
                                                              turmaAtual?.id
                                                          ? primaryDark
                                                          : Colors.transparent,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      e.nome,
                                                      style: TextStyle(
                                                          color: e.id ==
                                                                  turmaAtual?.id
                                                              ? backgroundDark
                                                              : branco50Dark),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      IconButton(
                                          onPressed: () async {
                                            try {
                                              await novaTurma(context);
                                            } on CronolabException catch (e) {
                                              switch (e.code) {
                                                case 8:
                                                  novaTurma(context, true,
                                                      e.data as String);
                                              }
                                            }
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: primaryDark,
                                          ))
                                    ]);
                              },
                              valueListenable: turmas.turmas,
                            )),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.help,
                                    color: primaryDark,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/ajuda");
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.person,
                                    color: primaryDark,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/perfil");
                                  },
                                ),
                              ],
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: const BoxDecoration(
                                  color: primaryDark,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12))),
                              child: DropdownButton<Turma?>(
                                  borderRadius: BorderRadius.circular(12),
                                  dropdownColor: primaryDark,
                                  underline: Container(),
                                  value: turmaAtual,
                                  items: [
                                    const DropdownMenuItem(
                                        child: Text("Todos"), value: null),
                                    ...turmas.turmas.value
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e.nome),
                                              value: e,
                                            ))
                                  ],
                                  onChanged: (novoValor) {
                                    //turmas.changeTurmaAtual(novoValor);
                                  }),
                            )
                          ],
                        ));
            })
      ],
    );
  }
}
