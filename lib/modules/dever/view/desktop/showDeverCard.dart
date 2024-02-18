import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cronolab/shared/colors.dart' as colors;

import 'package:intl/intl.dart';

class ShowDeverCard extends StatefulWidget {
  const ShowDeverCard(this.dever, {super.key});
  final Dever dever;
  @override
  State<ShowDeverCard> createState() => _ShowDeverCardState();
}

class _ShowDeverCardState extends State<ShowDeverCard> {
  DateFormat data = DateFormat("dd/MM");
  DateFormat hora = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
        backgroundColor: const Color(0xff332E33),
        contentPadding: EdgeInsets.zero,
        actions: [
          TextButton(
            child:
                const Text("Deletar", style: TextStyle(color: Colors.white38)),
            onPressed: GetIt.I.get<TurmasServer>().checkAdmin(widget.dever)
                ? () async {
                    var cancel = BotToast.showLoading();
                    try {
                      await GetIt.I
                          .get<TurmasServer>()
                          .deleteDever(widget.dever);
                    } catch (e) {
                      print(e);
                    } finally {
                      cancel();
                      GetIt.I
                          .get<TurmasServer>()
                          .getData()
                          .then((value) => Navigator.pop(context));
                    }
                  }
                : null,
          ),
          TextButton(
              child: Text(
                  (widget.dever.status ?? false) ? "Desfazer" : "Concluir"),
              onPressed: () async {
                var turmas = GetIt.I.get<TurmasServer>();
                await turmas.updateDever(widget.dever
                    .copyWith(status: !(widget.dever.status ?? false)));
                await turmas.getData();
                Navigator.pop(context);
              }),
        ],
        content: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            constraints: const BoxConstraints(maxHeight: 360, maxWidth: 576),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dever.title,
                                  style: const TextStyle(
                                      color: colors.whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                    GetIt.I
                                            .get<TurmasServer>()
                                            .getMateriaById(
                                                widget.dever.materiaID!)
                                            ?.nome ??
                                        "5",
                                    style: const TextStyle(
                                        color: colors.darkPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ]),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Valor: ${widget.dever.pontos.toString()}",
                                style: const TextStyle(
                                    color: colors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Nota: ",
                                  style: TextStyle(
                                      color: colors.whiteColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xff393939)),
                                  child: SingleChildScrollView(
                                      child:
                                          Text(widget.dever.descricao ?? "")))
                            ]),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      constraints: const BoxConstraints(maxHeight: 270),
                      width: 80,
                      margin: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 80, color: Colors.white),
                              Text(data.format(widget.dever.data),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.schedule_outlined,
                                  size: 80, color: Colors.white),
                              Text(hora.format(widget.dever.data),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  right: 100,
                  child: CustomPaint(
                      painter: FlagStatusPainter(widget.dever.deverUrgencia)))
            ])));
  }
}

class FlagStatusPainter extends CustomPainter {
  DeverUrgencia urgencia;
  FlagStatusPainter(this.urgencia);
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    paint.color = urgencia.index == DeverUrgencia.baixa.index
        ? const Color(0xff6AFA7C)
        : urgencia.index == DeverUrgencia.media.index
            ? const Color(0xffF4D072)
            : const Color(0xffF47B6E);
    paint.style = PaintingStyle.fill;

    path.moveTo(0, 0);
    path.lineTo(0, 53);
    path.lineTo(20, 30);
    path.lineTo(40, 53);
    path.lineTo(40, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
