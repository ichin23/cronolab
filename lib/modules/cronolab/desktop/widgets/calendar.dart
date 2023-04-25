import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/dia.dart';
import 'package:cronolab/modules/dever/view/desktop/cadastraDever.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
    //TODO: DeveresController.to.buildCalendar(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    var paddingHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    var paddingWidth = MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
    var size = MediaQuery.of(context).size;
    return Container();
    /*TODO: return Builder<DeveresController>(
      builder: (deveres) => Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
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
                            deveres.buildCalendar(DateTime(ano, mes));
                            setState(() {});
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      InkWell(
                        onTap: () {
                          deveres.buildCalendar(DateTime.now());
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
                                deveres.data.add(const Duration(days: 30)));
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
                                    style: const TextStyle(color: Colors.white),
                                  ))
                              .toList(),
                        ),
                        Expanded(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                /* ...List.filled(data.weekday, Container()),
                                Text(data.day.toString()) */
                                ...deveres.weeks
                                    .map(
                                        (e) => Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ...e
                                                      .map((f) => MouseRegion(
                                                            cursor:
                                                                SystemMouseCursors
                                                                    .click,
                                                            onEnter: (ev) {
                                                              if (f != null) {
                                                                debugPrint(
                                                                    f.deveres.toString());
                                                                if (f.deveres
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
                                                              if (f != null) {
                                                                if (f.deveres
                                                                    .isNotEmpty) {
                                                                  setState(() {
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
                                                                if (f != null) {
                                                                  if (!f.data.isBefore(deveres
                                                                      .hoje
                                                                      .subtract(
                                                                          const Duration(
                                                                              days: 1)))) {
                                                                    cliqueDireito(
                                                                        event,
                                                                        f,
                                                                        deveres);
                                                                  }
                                                                }
                                                              },
                                                              child: Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: (widget.height -
                                                                          80 -
                                                                          80) /
                                                                      deveres
                                                                          .weeks
                                                                          .length,
                                                                  width: (widget
                                                                              .height -
                                                                          80 -
                                                                          80) /
                                                                      deveres
                                                                          .weeks
                                                                          .length,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      border: f == deveres.diaAtual
                                                                          ? Border.all(
                                                                              color: primaryDark,
                                                                            )
                                                                          : null,
                                                                      color: f != null ? const Color(0xff3C353C) : Colors.transparent),
                                                                  child: f != null
                                                                      ? Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              f.data.day.toString(),
                                                                              style: TextStyle(
                                                                                  color: f.data.isAfter(deveres.ultimoDia) || f.data.isBefore(deveres.primeiroDia) || (f.data.month == deveres.hoje.month && f.data.isBefore(deveres.hoje.subtract(const Duration(days: 1))))
                                                                                      // || f.data.isBefore(diaI)
                                                                                      ? Colors.white24
                                                                                      : Colors.white,
                                                                                  fontSize: 40),
                                                                            ),
                                                                            f.deveres.isNotEmpty
                                                                                ? Container(
                                                                                    width: 10,
                                                                                    height: 10,
                                                                                    decoration: BoxDecoration(
                                                                                        color: (f.deveres[0] as Dever).data.day == deveres.hoje.day && (f.deveres[0] as Dever).data.month == deveres.hoje.month && (f.deveres[0] as Dever).data.year == deveres.hoje.year
                                                                                            ? const Color.fromARGB(255, 247, 150, 148)
                                                                                            : (f.deveres[0] as Dever).data.difference(DateTime.now()).inDays < 5
                                                                                                ? const Color.fromARGB(255, 245, 218, 147)
                                                                                                : const Color.fromARGB(255, 159, 245, 170),
                                                                                        shape: BoxShape.circle),
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        )
                                                                      : Container()),
                                                            ),
                                                          ))
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
        ],
      ),
    );*/
  }

  Future<void> cliqueDireito(
      PointerDownEvent event, Dia atual, DeveresController deveres) async {
    debugPrint(event.buttons.toString());
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      cadastraDeverDesktop(context, atual.data);
    } else {
      if (deveres.diaAtual == atual) {
        deveres.diaAtual = null;
      } else {
        deveres.diaAtual = atual;
      }
    }
  }
}
