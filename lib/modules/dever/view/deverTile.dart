import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';
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
    var turmas = Provider.of(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TapDownDetails tapDetails = TapDownDetails();
    // final width = MediaQuery.of(context).size.width;
    var data = widget.dever.data.toDate();
    Color corText = data.day == DateTime.now().day &&
            data.month == DateTime.now().month &&
            data.year == DateTime.now().year
        ? const Color(0xff813838)
        : data.difference(DateTime.now()).inDays < 5
            ? const Color(0xFF817938)
            : const Color(0xff3A8138);
    DateFormat dateStr = DateFormat("dd/MM");
    DateFormat hourStr = DateFormat("Hm");
    return GestureDetector(
      onTapDown: (tapDetail) {
        tapDetails = tapDetail;
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
                  await FirebaseFirestore.instance
                      .collection("turmas-test")
                      .doc(turmas.turmaAtual!.id)
                      .collection("deveres")
                      .doc(widget.dever.id)
                      .delete()
                      .then((value) => widget.notifyParent());
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
                Text(dateStr.format(widget.dever.data.toDate()),
                    style: TextStyle(color: corText)),
                Text(hourStr.format(DateTime(0, 0, 0, data.hour, data.minute)),
                    style: TextStyle(color: corText))
              ]),
              Column(
                children: [
                  Text(
                    widget.dever.title,
                    style: TextStyle(fontSize: 20, color: corText),
                    textAlign: TextAlign.center,
                  ),
                  Text(widget.dever.materia, style: TextStyle(color: corText))
                ],
              ),

              Text(" - " + widget.dever.pontos.toString() + " pts",
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
    var data = dever.data.toDate();
    return ListTile(
      title: Text(dever.title),
      subtitle: Text(dever.materia),
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
