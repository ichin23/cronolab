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
          child: const Text("Deletar", style: TextStyle(color: Colors.white38)),
          onPressed: GetIt.I.get<Turmas>().checkAdmin(widget.dever)
              ? () async {
                  var cancel = BotToast.showLoading();
                  try {
                    await GetIt.I.get<Turmas>().deleteDever(widget.dever);
                  } catch (e) {
                    print(e);
                  } finally {
                    cancel();
                    GetIt.I
                        .get<Turmas>()
                        .getData()
                        .then((value) => Navigator.pop(context));
                  }
                }
              : null,
        ),
        TextButton(
            child:
                Text((widget.dever.status ?? false) ? "Desfazer" : "Concluir"),
            onPressed: () async {
              var turmas = GetIt.I.get<Turmas>();
              await turmas.statusDever(
                  widget.dever.id!, !(widget.dever.status ?? false));
              await turmas.getData();
              Navigator.pop(context);
            }),
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.dever.title,
                              style: const TextStyle(
                                  color: colors.whiteColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                                GetIt.I
                                        .get<Turmas>()
                                        .getMateriaById(widget.dever.materiaID!)
                                        ?.nome ??
                                    "5",
                                style: const TextStyle(
                                    color: colors.darkPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ]),
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
                            Text("Local: ${widget.dever.local ?? ''}",
                                style: const TextStyle(
                                    color: colors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
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
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xff393939)))
                          ])
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
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
                                    fontSize: 14,
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container()
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 100,
                child: CustomPaint(
                    painter: FlagStatusPainter(widget.dever.deverUrgencia)))
          ],
        ),
      ),
    );
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
