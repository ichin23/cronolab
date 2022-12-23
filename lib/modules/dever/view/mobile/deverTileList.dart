import 'package:cronolab/modules/dever/dever.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeverTileList extends StatefulWidget {
  const DeverTileList({Key? key, required this.dever, required this.index})
      : super(key: key);
  final Dever dever;
  final int index;

  @override
  State<DeverTileList> createState() => _DeverTileListState();
}

class _DeverTileListState extends State<DeverTileList> {
  @override
  Widget build(BuildContext context) {
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
    DateFormat hourStr = DateFormat("HH:mm");

    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        constraints: BoxConstraints(minHeight: 75),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.dever.status!
              ? const Color.fromRGBO(182, 181, 181, 1)
              : data.difference(DateTime.now()).inDays < 1
                  ? const Color(0xffFFD1D0)
                  : data.difference(DateTime.now()).inDays < 5
                      ? const Color(0xFFFBF5C5)
                      : const Color(0xffBDF6E3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "title${widget.index.toString()}",
                      child: Text(widget.dever.title,
                          style: TextStyle(
                              color: corText,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 5),
                    Text(widget.dever.materia!.nome,
                        style: TextStyle(color: corText, fontSize: 16)),
                  ]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Hero(
                  tag: "data${widget.index.toString()}",
                  child: Text(dataStr.format(widget.dever.data),
                      style: TextStyle(color: corText, fontSize: 14)),
                ),
                Hero(
                  tag: "pontos${widget.index.toString()}",
                  child: Text(
                    widget.dever.pontos.toString() + " pontos",
                    style: TextStyle(color: corText, fontSize: 14),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
