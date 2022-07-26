import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'popit.dart';

class DeverTile2 extends StatefulWidget {
  final Function() notifyParent;
  const DeverTile2(this.dever, {Key? key, required this.notifyParent})
      : super(key: key);
  final Dever dever;

  @override
  State<DeverTile2> createState() => _DeverTile2State();
}

class _DeverTile2State extends State<DeverTile2> {
  @override
  Widget build(BuildContext context) {
    var turmas = TurmasState.to;
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

    // print(data.day + DateTime.now().day + data.day == DateTime.now().day);
    PopItColor corPop = data.day == DateTime.now().day &&
            data.month == DateTime.now().month &&
            data.year == DateTime.now().year
        ? PopItColor.vermelho
        : data.difference(DateTime.now()).inDays < 5
            ? PopItColor.amarelo
            : PopItColor.verde;
    // print(corPop.toString() + widget.dever.title);
    DateFormat dateStr = DateFormat("dd/MM");
    DateFormat hourStr = DateFormat("Hm");
    return GestureDetector(
        onTapDown: (tapDetail) {
          tapDetails = tapDetail;
        },
        onTap: () {
          Get.toNamed("/dever", arguments: widget.dever);
        },
        onLongPress: () {
          showMenu(
              color: black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
        child: Stack(
          children: [
            PopIt(corPop),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.dever.title,
                        //  style: GoogleFonts.indieFlower(
                        //    fontSize: 26, color: Colors.black.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.dever.materia!.nome,
                        // style: GoogleFonts.indieFlower(
                        //   fontSize: 20, color: Colors.black.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.dever.pontos.toString() + "pts",
                        //  style: GoogleFonts.indieFlower(
                        //    fontSize: 18, color: Colors.black.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  SizedBox(height: (width / 2 - 25) * 0.2),
                  Text(
                    dateStr.format(widget.dever.data) +
                        " - " +
                        hourStr.format(widget.dever.data),
                    // style: GoogleFonts.indieFlower(
                    //   fontSize: 25, color: Colors.black.withOpacity(0.7)),
                  )
                ],
              ),
            )
          ],
        ));
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
