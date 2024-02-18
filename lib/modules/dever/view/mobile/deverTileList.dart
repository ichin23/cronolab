import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/dever/view/desktop/showDeverCard.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class DeverTileList extends StatefulWidget {
  const DeverTileList(
      {Key? key, required this.dever, required this.index, this.notifyParent})
      : super(key: key);
  final Dever dever;
  final int index;
  final Function? notifyParent;

  @override
  State<DeverTileList> createState() => _DeverTileListState();
}

class _DeverTileListState extends State<DeverTileList> {
  List<PopupMenuItem> popMenu = [];
  late TurmasServer turmas;
  @override
  void initState() {
    turmas = GetIt.I.get<TurmasServer>();
    super.initState();
    //var turmas = Provider.of<Turmas>(context, listen:false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!kIsWeb) {
        popMenu.add(
          PopupMenuItem(
            child: Text("Concluída",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            onTap: () async {
              /*if (widget.dever.status == true) {
                await context
                    .read<Turmas>()
                    .turmasSQL
                    .updateDever(widget.dever..status = false);
              } else {
                await context
                    .read<Turmas>()
                    .turmasSQL
                    .updateDever(widget.dever..status = true);
              }

              await context.read<Turmas>().getData();*/
              if (widget.notifyParent != null) {
                widget.notifyParent!();
              }
              // await turmas.setDeverStatus(
              //     widget.dever.id!, !widget.dever.status!);
              // Provider.of<IndexController>(context).refreshDb(context);
            },
          ),
        );
        /* if (context.read<Turmas>().turmaAtual!.isAdmin) {
          popMenu.add(
            PopupMenuItem(
              child: Text("Excluir",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              onTap: () async {
                var date = Timestamp.fromDate((await context
                        .read<Turmas>()
                        .turmasFB
                        .deleteDever(widget.dever,
                            context.read<Turmas>().turmaAtual!.id))
                    .toDate()
                    .subtract(const Duration(minutes: 3)));
                var newDeveres = await context
                    .read<Turmas>()
                    .turmasFB
                    .refreshTurma(context.read<Turmas>().turmaAtual!.id, date);
                for (var dever in newDeveres) {
                  await context.read<Turmas>().turmasSQL.createDever(
                      dever, context.read<Turmas>().turmaAtual!.id);
                }
                await context.read<Turmas>().getData();
                if (widget.notifyParent != null) {
                  widget.notifyParent!();
                }
              },
            ),
          );
        }
      } else {
        Turma? turma = context
            .read<TurmasStateDesktop>()
            .getTurmaByDever(widget.dever.id!);
        if (turma?.isAdmin ?? false) {
          popMenu.add(
            PopupMenuItem(
              child: Text("Excluir",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              onTap: () {
                turma?.deleteDever(context, widget.dever.id!).then((value) {
                  turma.getAtividadesDesk(context).then((value) => context
                      .read<DeveresController>()
                      .buildCalendar(DateTime.now(), context));
                });
              },
            ),
          );
        }*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TapDownDetails tapDetails = TapDownDetails();
    var data = widget.dever.data;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Color corText = widget.dever.status ?? false
        ? const Color.fromARGB(255, 109, 109, 109)
        : widget.dever.deverUrgencia == DeverUrgencia.alta
            ? const Color(0xff813838)
            : widget.dever.deverUrgencia == DeverUrgencia.media
                ? const Color(0xFF817938)
                : const Color(0xff3A8138);

    DateFormat dataStr = DateFormat("dd/MM - HH:mm");
    DateFormat horaStr = DateFormat(" - HH:mm");

    return GestureDetector(
      onTapDown: (tapDetail) {
        tapDetails = tapDetail;
      },
      onTap: () {
        //debugPrint(
        //  "NOW: ${DateTime.now().millisecondsSinceEpoch}\nDever: ${widget.dever.data.millisecondsSinceEpoch}");
        if (!kIsWeb) {
          showDialog(
              context: context,
              builder: (context) => ShowDeverCard(widget.dever)).then((value) {
            if (widget.notifyParent != null) {
              widget.notifyParent!();
            }
          });
          //Navigator.pushNamed(context, "/dever",
          // arguments: {"dever": widget.dever, "index": widget.index});
        } else {
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
        }
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
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          constraints: const BoxConstraints(minHeight: 75),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.dever.status ?? false
                ? const Color.fromRGBO(182, 181, 181, 1)
                : widget.dever.deverUrgencia == DeverUrgencia.alta
                    ? const Color(0xffFFD1D0)
                    : widget.dever.deverUrgencia == DeverUrgencia.media
                        ? const Color(0xFFFBF5C5)
                        : const Color(0xffBDF6E3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Hero(
                  tag: "title${widget.index.toString()}",
                  child: Text(widget.dever.title,
                      style: TextStyle(
                          color: corText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 5),
                Text(
                    turmas.materias
                            .where((element) =>
                                element.id == widget.dever.materiaID)
                            .first
                            .nome ??
                        "",
                    style: TextStyle(color: corText, fontSize: 16)),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Hero(
                    tag: "data${widget.index.toString()}",
                    child: Text(
                        (data.difference(DateTime.now()).inDays == 0
                                ? "Hoje"
                                : data
                                        .difference(DateTime.now())
                                        .inDays
                                        .toString() +
                                    " dias") +
                            horaStr.format(data),
                        style: TextStyle(color: corText, fontSize: 14)),
                    /* child: Text(dataStr.format(widget.dever.data),
                        style: TextStyle(color: corText, fontSize: 14)), */
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
          )),
    );
  }
}
