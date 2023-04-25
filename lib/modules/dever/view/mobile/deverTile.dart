import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';

import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeverTile extends StatefulWidget {
  final Function()? notifyParent;

  const DeverTile(this.dever,
      {Key? key, required this.notifyParent, required this.index})
      : super(key: key);
  final Dever dever;
  final int index;

  @override
  State<DeverTile> createState() => _DeverTileState();
}

class _DeverTileState extends State<DeverTile> {
  List<PopupMenuItem> popMenu = [];

  @override
  void initState() {
    super.initState();
    //var turmas = Provider.of<Turmas>(context, listen:false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      popMenu.add(
        PopupMenuItem(
          child: Text("Concluída",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          onTap: () async {
            // await turmas.setDeverStatus(
            //     widget.dever.id!, !widget.dever.status!);
            // Provider.of<IndexController>(context).refreshDb(context);
          },
        ),
      );
      if (context.read<Turmas>().turmaAtual!.isAdmin) {
        popMenu.add(
          PopupMenuItem(
            child: Text("Excluir",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            onTap: () async {
              await context.read<Turmas>().turmasSQL!.deleteDever(widget.dever);

              await context.read<Turmas>().getData();
              if (widget.notifyParent != null) {
                widget.notifyParent!();
              }
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var turmas = Provider.of<TurmasState>(context);
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
        Navigator.pushNamed(context, "/dever", arguments: widget.dever);
      },
      onLongPress: () {
        showMenu(
          color: backgroundDark,
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
        child: Consumer<Turmas>(builder: (context, turmas, child) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // gradient: LinearGradient(
              //     colors: [Colors.red[300]!, Colors.red[700]!],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight),
              color: widget.dever.status ?? false
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
                Hero(
                  tag: "data${widget.index.toString()}",
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dateStr.format(widget.dever.data),
                            style: TextStyle(color: corText, fontSize: 15)),
                        Text(hourStr.format(widget.dever.data),
                            style: TextStyle(color: corText, fontSize: 15)),
                      ]),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "title${widget.index.toString()}",
                      child: Text(widget.dever.title,
                          style: TextStyle(
                              color: corText,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                    ),
                    Text(widget.dever.materia?.nome ?? "----",
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
                Hero(
                  tag: "pontos${widget.index.toString()}",
                  child: Text(
                      (int.parse(widget.dever.pontos
                                      .toString()
                                      .split(".")[1]) ==
                                  0
                              ? widget.dever.pontos!.toStringAsFixed(0)
                              : widget.dever.pontos.toString()) +
                          " pontos",
                      style: TextStyle(color: corText)),
                ),

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
          );
        }),
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
      subtitle: Text(dever.materiaID.toString()),
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
