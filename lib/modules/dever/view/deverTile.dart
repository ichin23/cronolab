import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeverTile extends StatefulWidget {
  final Function() notifyParent;
  const DeverTile(this.dever, {Key? key, required this.notifyParent})
      : super(key: key);
  final Dever dever;

  @override
  State<DeverTile> createState() => _DeverTileState();
}

class _DeverTileState extends State<DeverTile> {
  @override
  Widget build(BuildContext context) {
    var turmas = Provider.of<TurmasProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TapDownDetails tapDetails = TapDownDetails();
    // final width = MediaQuery.of(context).size.width;
    var data = widget.dever.data;
    Color corText = data.day == DateTime.now().day &&
            data.month == DateTime.now().month &&
            data.year == DateTime.now().year
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
        Navigator.pushNamed(context, "/dever", arguments: widget.dever);
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
            items: [
              PopupMenuItem(
                child: const Text("Excluir",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center),
                onTap: () async {
                  turmas.turmaAtual!
                      .deleteDever(widget.dever.id!)
                      .then((value) => widget.notifyParent());
                  // Delete Dever await FirebaseFirestore.instance
                  //     .collection("turmas-test")
                  //     .doc(turmas.turmaAtual!.id)
                  //     .collection("deveres")
                  //     .doc(widget.dever.id)
                  //     .delete()
                  //     .then((value) => widget.notifyParent());
                },
              ),
              PopupMenuItem(
                enabled: false,
                child: const Text("Concluída",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center),
                onTap: () async {},
              ),
            ]);
      },
      child: Container(
        margin: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // gradient: LinearGradient(
            //     colors: [Colors.red[300]!, Colors.red[700]!],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight),
            color: data.day == DateTime.now().day &&
                    data.month == DateTime.now().month &&
                    data.year == DateTime.now().year
                ? const Color(0xffFFD1D0)
                : data.difference(DateTime.now()).inDays < 5
                    ? const Color(0xFFFBF5C5)
                    : const Color(0xffBDF6E3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(widget.dever.title,
                    style: TextStyle(color: corText, fontSize: 17)),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.dever.materia!.nome,
                      style: TextStyle(color: corText, fontSize: 17)),
                  Text(
                      (int.parse(widget.dever.pontos
                                      .toString()
                                      .split(".")[1]) ==
                                  0
                              ? widget.dever.pontos!.toStringAsFixed(0)
                              : widget.dever.pontos.toString()) +
                          " pontos",
                      style: TextStyle(color: corText)),
                ],
              ),
              Container(),
              Text(dataStr.format(widget.dever.data),
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
