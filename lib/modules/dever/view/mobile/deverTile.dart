import 'package:cronolab/modules/cronolab/mobile/controller/indexController.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DeverTile extends StatefulWidget {
  final Function()? notifyParent;
  const DeverTile(this.dever, {Key? key, required this.notifyParent})
      : super(key: key);
  final Dever dever;

  @override
  State<DeverTile> createState() => _DeverTileState();
}

class _DeverTileState extends State<DeverTile> {
  List<PopupMenuItem> popMenu = [];
  @override
  void initState() {
    super.initState();
    var turmas = TurmasLocal.to;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      popMenu.add(
        PopupMenuItem(
          child: const Text("Concluída",
              style: TextStyle(color: white), textAlign: TextAlign.center),
          onTap: () async {
            await turmas.setDeverStatus(
                widget.dever.id!, !widget.dever.status!);
            Get.find<IndexController>().refreshDb();
          },
        ),
      );
      if (turmas.turmaAtual!.isAdmin) {
        popMenu.add(
          PopupMenuItem(
            child: const Text("Excluir",
                style: TextStyle(color: white), textAlign: TextAlign.center),
            onTap: () async {
              turmas.turmaAtual!.deleteDever(widget.dever.id!).then((value) {
                Get.find<IndexController>().refreshDb();
              });
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var turmas = TurmasState.to;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TapDownDetails tapDetails = TapDownDetails();
    // final width = MediaQuery.of(context).size.width;
    var data = widget.dever.data;
    Color corText = widget.dever.status ?? false
        ? const Color.fromARGB(255, 109, 109, 109)
        : data.difference(DateTime.now()).inDays < 1
            ? const Color(0xff813838)
            : data.difference(DateTime.now()).inDays < 5
                ? const Color(0xFF817938)
                : const Color(0xff3A8138);
    DateFormat dateStr = DateFormat("dd/MM");
    DateFormat dataStr = DateFormat("dd/MM - HH:mm");
    DateFormat hourStr = DateFormat("Hm");
    return GestureDetector(
      onTapDown: (tapDetail) {
        tapDetails = tapDetail;
      },
      onTap: () {
        //debugPrint(
        //  "NOW: ${DateTime.now().millisecondsSinceEpoch}\nDever: ${widget.dever.data.millisecondsSinceEpoch}");
        Get.toNamed("/dever", arguments: widget.dever);
      },
      onLongPress: () {
        showMenu(
          color: black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          context: context,
          position: RelativeRect.fromLTRB(
              tapDetails.globalPosition.dx,
              tapDetails.globalPosition.dy,
              width - tapDetails.globalPosition.dx,
              height - tapDetails.globalPosition.dy),
          items: [...popMenu],
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // gradient: LinearGradient(
            //     colors: [Colors.red[300]!, Colors.red[700]!],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight),
            color: widget.dever.status!
                ? const Color.fromRGBO(182, 181, 181, 1)
                : data.difference(DateTime.now()).inDays < 1
                    ? const Color(0xffFFD1D0)
                    : data.difference(DateTime.now()).inDays < 5
                        ? const Color(0xFFFBF5C5)
                        : const Color(0xffBDF6E3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(dateStr.format(widget.dever.data),
                    style: TextStyle(color: corText, fontSize: 15)),
                Text(hourStr.format(widget.dever.data),
                    style: TextStyle(color: corText, fontSize: 15)),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.dever.title,
                      style: TextStyle(
                          color: corText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  Text(widget.dever.materia!.nome,
                      style: TextStyle(color: corText, fontSize: 17)),
                  /* Text(
                      (int.parse(widget.dever.pontos
                                      .toString()
                                      .split(".")[1]) ==
                                  0
                              ? widget.dever.pontos!.toStringAsFixed(0)
                              : widget.dever.pontos.toString()) +
                          " pontos",
                      sty le: TextStyle(color: corText)),*/
                ],
              ),
              Container(),
              Text(
                  (int.parse(widget.dever.pontos.toString().split(".")[1]) == 0
                          ? widget.dever.pontos!.toStringAsFixed(0)
                          : widget.dever.pontos.toString()) +
                      " pontos",
                  style: TextStyle(color: corText)),

              // Container(
              //     width: width * 0.1,
              //     child: Column(children: [
              //       Text(data.day.toString() +
              //           "/" +
              //           data.month.toString())
              //     ])),
            ],
            // title: Text(dever.title),
            // subtitle: Text(dever.materia),
            // trailing: Text(dever.pontos.toString() + " pts"),
            // leading: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(data.day.toString() +
            //         "/" +
            //         data.month.toString()),
            //     Text(data.hour.toString() +
            //         ":" +
            //         data.minute.toString()),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}

class Original extends StatelessWidget {
  const Original(this.dever, {Key? key}) : super(key: key);
  final Dever dever;
  @override
  Widget build(BuildContext context) {
    var data = dever.data;
    return ListTile(
      title: Text(dever.title),
      subtitle: Text(dever.materia!.nome),
      trailing: Text(dever.pontos.toString() + " pts"),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.day.toString() + "/" + data.month.toString()),
          Text(data.hour.toString() + ":" + data.minute.toString()),
        ],
      ),
    );
  }
}
