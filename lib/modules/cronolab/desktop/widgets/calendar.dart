import 'package:cronolab/modules/dever/view/desktop/cadastraDever.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dia.dart';

class Calendar extends StatefulWidget {
  const Calendar(this.width, this.height, {Key? key}) : super(key: key);
  final double width;
  final double height;

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime hoje = DateTime.now();
  DateTime data = DateTime.now();
  late DateTime diaI;
  late DateTime ultimoDia;
  late DateTime primeiroDia;
  bool dia1Pronto = false;

  bool showDeveres = false;
  Offset? showDeveresPosition;
  List deveresToShow = [];

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

  List week = [];
  List<List<Dia?>> weeks = [];
  DateFormat hourStr = DateFormat("Hm");
  buildCalendar(DateTime newData) {
    data = newData;
    weeks.clear();
    dia1Pronto = false;

    primeiroDia = DateTime(data.year, data.month, 1);
    ultimoDia = DateTime(primeiroDia.year, primeiroDia.month + 1, 0);
    diaI = primeiroDia;
    var turmas = TurmasState.to.turmaAtual;
    while (diaI.day <= ultimoDia.day) {
      weeks.add(List.generate(7, (index) {
        if (!dia1Pronto) {
          if (index == diaI.weekday) {
            dia1Pronto = true;
            return Dia(
                diaI,
                turmas!.deveres!
                    .where((dever) =>
                        dever.data.day == diaI.day &&
                        dever.data.month == diaI.month &&
                        dever.data.year == diaI.year)
                    .toList());
          } else {
            return Dia(
                diaI.subtract(
                    Duration(days: 7 - (7 - diaI.weekday + 1) - index + 1)),
                turmas!.deveres!
                    .where((dever) =>
                        dever.data.day == diaI.day &&
                        dever.data.month == diaI.month &&
                        dever.data.year == diaI.year)
                    .toList());
          }
        } else {
          diaI = diaI.add(const Duration(days: 1));
          return Dia(
              diaI,
              turmas!.deveres!
                  .where((dever) =>
                      dever.data.day == diaI.day &&
                      dever.data.month == diaI.month &&
                      dever.data.year == diaI.year)
                  .toList());
        }
      }));
      if (diaI.isAfter(ultimoDia) || diaI.isAtSameMomentAs(ultimoDia)) {
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    buildCalendar(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    var paddingHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    var paddingWidth = MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
    var size = MediaQuery.of(context).size;
    return Stack(
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
                          buildCalendar(
                              data.subtract(const Duration(days: 30)));
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    Text(
                      "${months[data.month - 1]} - ${data.year.toString()}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {
                          buildCalendar(data.add(const Duration(days: 30)));
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
                              ...weeks
                                  .map((e) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ...e
                                                .map((f) => MouseRegion(
                                                      cursor: SystemMouseCursors
                                                          .click,
                                                      onEnter: (ev) {
                                                        if (f != null) {
                                                          if (f.deveres
                                                              .isNotEmpty) {
                                                            setState(() {
                                                              deveresToShow =
                                                                  f.deveres;
                                                              showDeveres =
                                                                  true;
                                                              showDeveresPosition =
                                                                  ev.position;
                                                            });
                                                            print(size.height);
                                                            print(showDeveresPosition!
                                                                        .dy -
                                                                    paddingHeight -
                                                                    widget.height *
                                                                        0.2 +
                                                                    widget.width *
                                                                        0.4 >
                                                                size.height);
                                                          }
                                                        }
                                                      },
                                                      onExit: (ev) {
                                                        if (f != null) {
                                                          if (f.deveres
                                                              .isNotEmpty) {
                                                            setState(() {
                                                              deveresToShow =
                                                                  [];
                                                              showDeveres =
                                                                  false;
                                                              showDeveresPosition =
                                                                  null;
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: Listener(
                                                        onPointerDown: (event) {
                                                          if (f != null) {
                                                            /* showMenu(
                                                                    context:
                                                                        context,
                                                                    color:
                                                                        black,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20)),
                                                                    position: RelativeRect.fromLTRB(
                                                                        event
                                                                            .position
                                                                            .dx,
                                                                        event
                                                                            .position
                                                                            .dy,
                                                                        size.width -
                                                                            event.position.dx,
                                                                        0),
                                                                    items: [
                                                                      PopupMenuItem(
                                                                          onTap:
                                                                              () async {
                                                                            print("ok");
                                                                            Navigator.pop(context);
                                                                            await cadastraDeverDesktop(context,
                                                                                f.data);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            "Cadastra atividade",
                                                                            style:
                                                                                TextStyle(color: primary2),
                                                                          ))
                                                                    ]); */
                                                            if (!f.data.isBefore(
                                                                hoje.subtract(
                                                                    const Duration(
                                                                        days:
                                                                            1)))) {
                                                              cliqueDireito(
                                                                  event,
                                                                  f.data);
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: (widget
                                                                        .height -
                                                                    80 -
                                                                    80) /
                                                                weeks.length,
                                                            width:
                                                                (widget.width -
                                                                        30 -
                                                                        100) /
                                                                    7,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: f != null
                                                                    ? f.data.day == hoje.day && f.data.month == hoje.month
                                                                        ? const Color(0xffACBDF5)
                                                                        : const Color(0xff3C353C)
                                                                    : Colors.transparent),
                                                            child: f != null
                                                                ? Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        f.data
                                                                            .day
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color: f.data.isAfter(ultimoDia) || f.data.isBefore(primeiroDia) || (f.data.month==hoje.month && f.data.isBefore(hoje.subtract(const Duration(days:1))))
                                                                                // || f.data.isBefore(diaI)
                                                                                ? Colors.white24
                                                                                : Colors.white,
                                                                            fontSize: 40),
                                                                      ),
                                                                      f.deveres
                                                                              .isNotEmpty
                                                                          ? Container(
                                                                              width: 10,
                                                                              height: 10,
                                                                              decoration: const BoxDecoration(color: primary2, shape: BoxShape.circle),
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
        showDeveres
            ? Positioned(
                left: showDeveresPosition!.dx -
                    paddingWidth -
                    size.width * 0.17 +
                    2,
                top: showDeveresPosition!.dy -
                            paddingHeight -
                            widget.height * 0.2 +
                            widget.width * 0.4 >
                        size.height
                    ? size.height - widget.height * 0.25
                    : showDeveresPosition!.dy -
                        paddingHeight -
                        widget.height * 0.2,
                child: Container(
                  width: widget.width * 0.3,
                  height: widget.height * 0.2,
                  decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: primary2, style: BorderStyle.solid, width: 4)),
                  child: ListView.builder(
                      itemCount: deveresToShow.length,
                      itemBuilder: (context, i) => ListTile(
                            tileColor: black,
                            trailing: Text(
                              hourStr.format(deveresToShow[i].data),
                              style: label,
                            ),
                            title: Text(
                              deveresToShow[i].title +
                                  " - " +
                                  deveresToShow[i].materia.nome,
                              style: label,
                            ),
                          )),
                ),
              )
            : Container()
      ],
    );
  }

  Future<void> cliqueDireito(PointerDownEvent event, DateTime data) async {
    print(event.buttons == kSecondaryMouseButton);
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      cadastraDeverDesktop(context, data);
    }
  }
}
