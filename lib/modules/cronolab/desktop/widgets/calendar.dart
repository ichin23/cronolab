//import 'dart:html' if (dart.library.html) 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/dia.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/dever/view/desktop/cadastraDever.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Calendar extends StatefulWidget {
  const Calendar(this.width, this.height, {Key? key}) : super(key: key);
  final double width;
  final double height;

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  List<String> dias = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
  List<String> months = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      //document.onContextMenu.listen((event) => event.preventDefault());
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ValueListenableBuilder<DeveresController>(
      valueListenable: ValueNotifier(GetIt.I.get<DeveresController>()),
      builder: (context, deveres, _) => Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(minHeight: 500),
              height: size.height * 0.9,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: widget.width,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xffACBDF5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              int mes = deveres.data.month;
                              int ano = deveres.data.year;
                              if (mes == 1) {
                                mes = 12;
                                ano -= 1;
                              } else {
                                mes -= 1;
                              }
                              deveres.buildCalendar(
                                  DateTime(ano, mes), context);
                              setState(() {});
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        InkWell(
                          onTap: () {
                            deveres.buildCalendar(DateTime.now(), context);
                            setState(() {});
                          },
                          child: Text(
                            "${months[deveres.data.month - 1]} - ${deveres.data.year.toString()}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              deveres.buildCalendar(
                                  deveres.data.add(const Duration(days: 30)),
                                  context);
                              setState(() {});
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color(0xff252125),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      width: widget.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: dias
                                .map((e) => Text(
                                      e,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ))
                                .toList(),
                          ),
                          Expanded(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  /* ...List.filled(data.weekday, Container()),
                                  Text(data.day.toString()) */
                                  ...deveres.weeks
                                      .map((e) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ...e
                                                    .map((f) =>
                                                        ValueListenableBuilder<
                                                                Dia?>(
                                                            valueListenable:
                                                                deveres
                                                                    .diaAtualList,
                                                            builder: (context,
                                                                dia, _) {
                                                              return MouseRegion(
                                                                cursor:
                                                                    SystemMouseCursors
                                                                        .click,
                                                                onEnter: (ev) {
                                                                  if (f !=
                                                                      null) {
                                                                    if (f
                                                                        .deveres
                                                                        .isNotEmpty) {
                                                                      deveres.deveresToShow =
                                                                          f.deveres;
                                                                      deveres.showDeveres =
                                                                          true;
                                                                      deveres.showDeveresPosition =
                                                                          ev.position;
                                                                    }
                                                                  }
                                                                },
                                                                onExit: (ev) {
                                                                  if (f !=
                                                                      null) {
                                                                    if (f
                                                                        .deveres
                                                                        .isNotEmpty) {
                                                                      setState(
                                                                          () {
                                                                        deveres.deveresToShow =
                                                                            [];
                                                                        deveres.showDeveres =
                                                                            false;
                                                                        deveres.showDeveresPosition =
                                                                            null;
                                                                        // deveres.diaAtual =
                                                                        //     null;
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                                child: Listener(
                                                                  onPointerDown:
                                                                      (event) {
                                                                    if (f !=
                                                                        null) {
                                                                      if (!f.data.isBefore(deveres
                                                                          .hoje
                                                                          .subtract(
                                                                              const Duration(days: 1)))) {
                                                                        cliqueDireito(
                                                                            event,
                                                                            f,
                                                                            deveres);
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                      alignment: Alignment.center,
                                                                      height: (widget.height - 100) / deveres.weeks.length - 10,
                                                                      //width: 60,
                                                                      width: (widget.width - 30) / 7 - 10,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          border: f == dia
                                                                              ? Border.all(
                                                                                  color: primaryDark,
                                                                                  width: 3,
                                                                                )
                                                                              : null,
                                                                          color: f != null
                                                                              ? f.deveres.isNotEmpty
                                                                                  ? (f.deveres[0] as Dever).deverUrgencia == DeverUrgencia.alta
                                                                                      ? const Color.fromARGB(255, 247, 150, 148)
                                                                                      : (f.deveres[0] as Dever).deverUrgencia == DeverUrgencia.media
                                                                                          ? const Color.fromARGB(255, 245, 218, 147)
                                                                                          : const Color.fromARGB(255, 159, 245, 170)
                                                                                  : const Color(0xff3C353C)
                                                                              : Colors.transparent),
                                                                      child: f != null
                                                                          ? Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                AutoSizeText(
                                                                                  f.data.day.toString(),
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(
                                                                                      color: f.data.isAfter(deveres.ultimoDia) || f.data.isBefore(deveres.primeiroDia) || (f.data.month == deveres.hoje.month && f.data.isBefore(deveres.hoje.subtract(const Duration(days: 1))))
                                                                                          // || f.data.isBefore(diaI)
                                                                                          ? Colors.white24
                                                                                          : f.deveres.isNotEmpty
                                                                                              ? backgroundDark
                                                                                              : Colors.white,
                                                                                      fontWeight: FontWeight.w800,
                                                                                      fontSize: f == dia ? 36 : 40),
                                                                                ),
                                                                                // f.deveres.isNotEmpty
                                                                                //     ? Container(
                                                                                //         width: 10,
                                                                                //         height: 10,
                                                                                //         decoration: BoxDecoration(
                                                                                //             color: (f.deveres[0] as Dever).data.day == deveres.hoje.day && (f.deveres[0] as Dever).data.month == deveres.hoje.month && (f.deveres[0] as Dever).data.year == deveres.hoje.year
                                                                                //                 ? const Color.fromARGB(255, 247, 150, 148)
                                                                                //                 : (f.deveres[0] as Dever).data.difference(DateTime.now()).inDays < 5
                                                                                //                     ? const Color.fromARGB(255, 245, 218, 147)
                                                                                //                     : const Color.fromARGB(255, 159, 245, 170),
                                                                                //             shape: BoxShape.circle),
                                                                                //       )
                                                                                //     : Container(),
                                                                              ],
                                                                            )
                                                                          : Container()),
                                                                ),
                                                              );
                                                            }))
                                                    .toList()
                                              ]))
                                      .toList()
                                ]),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cliqueDireito(
      PointerDownEvent event, Dia atual, DeveresController deveres) async {
    debugPrint(event.buttons.toString());
    var turmas = GetIt.I.get<TurmasServer>();

    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton &&
        turmas.turmaAtual.value != null &&
        (turmas.turmaAtual.value?.isAdmin ?? false)) {
      await cadastraDeverDesktop(context, atual.data);
      await turmas.getData();
      deveres.buildCalendar(DateTime.now(), context);
    } else {
      if (deveres.diaAtual == atual) {
        deveres.diaAtual = null;
      } else {
        deveres.diaAtual = atual;
      }
    }
  }
}
