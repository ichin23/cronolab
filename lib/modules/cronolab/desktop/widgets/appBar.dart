import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:cronolab/shared/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarDesktop extends StatefulWidget {
  const AppBarDesktop({Key? key}) : super(key: key);

  @override
  State<AppBarDesktop> createState() => _AppBarDesktopState();
}

class _AppBarDesktopState extends State<AppBarDesktop> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
                color: backgroundDark,
                border:
                    Border(bottom: BorderSide(color: primaryDark, width: 3))),
            //padding: const EdgeInsets.all(8),
            width: size.width,
            height: 46,
            child: size.width > 800
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          context
                              .read<TurmasStateDesktop>()
                              .changeTurmaAtual(null);
                          await context
                              .read<TurmasStateDesktop>()
                              .refreshDeveres(context);
                          context
                              .read<DeveresController>()
                              .buildCalendar(DateTime.now(), context);
                        },
                        child: Consumer<TurmasStateDesktop>(
                            builder: (context, turmas, _) {
                          return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: turmas.turmaAtual == null
                                      ? primaryDark
                                      : Colors.transparent),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Cronolab",
                                style: TextStyle(
                                    color: turmas.turmaAtual == null
                                        ? backgroundDark
                                        : primaryDark),
                              ));
                        }),
                      ),
                      Consumer<TurmasStateDesktop>(
                          builder: (context, turmas, _) {
                        return Expanded(
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                              ...turmas.turmas
                                  .map(
                                    (e) => Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: InkWell(
                                          onTap: () async {
                                            context
                                                .read<TurmasStateDesktop>()
                                                .changeTurmaAtual(e);
                                            await context
                                                .read<TurmasStateDesktop>()
                                                .refreshDeveres(context);
                                            context
                                                .read<DeveresController>()
                                                .buildCalendar(
                                                    DateTime.now(), context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(0)),
                                              color:
                                                  e.id == turmas.turmaAtual?.id
                                                      ? primaryDark
                                                      : Colors.transparent,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              e.nome,
                                              style: TextStyle(
                                                  color: e.id ==
                                                          turmas.turmaAtual?.id
                                                      ? backgroundDark
                                                      : branco50Dark),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              IconButton(
                                  onPressed: () {
                                    TextEditingController code =
                                        TextEditingController();
                                    bool loading = false;

                                    showDialog(
                                        context: context,
                                        builder:
                                            (context) =>
                                                turmas.turmas.length <
                                                        context
                                                            .read<Settings>()
                                                            .limTurmas
                                                    ? StatefulBuilder(builder:
                                                        (context, setstate) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    minHeight:
                                                                        100),
                                                            child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    "Digite o código da turma",
                                                                    style:
                                                                        labelDark,
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  TextField(
                                                                    style:
                                                                        labelDark,
                                                                    controller:
                                                                        code,
                                                                    onSubmitted:
                                                                        (codeStr) async {
                                                                      loading =
                                                                          true;
                                                                      setstate(
                                                                          () {});
                                                                      await context
                                                                          .read<
                                                                              TurmasStateDesktop>()
                                                                          .initTurma(
                                                                              codeStr,
                                                                              context);

                                                                      loading =
                                                                          false;
                                                                      setstate(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                      await context
                                                                          .read<
                                                                              TurmasStateDesktop>()
                                                                          .getTurmas(
                                                                              context);
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  TextButton(
                                                                    child: loading
                                                                        ? const CircularProgressIndicator()
                                                                        : const Text(
                                                                            "Adicionar"),
                                                                    onPressed:
                                                                        loading
                                                                            ? null
                                                                            : () async {
                                                                                loading = true;
                                                                                setstate(() {});
                                                                                await context.read<TurmasStateDesktop>().initTurma(code.text, context);

                                                                                loading = false;
                                                                                setstate(() {});
                                                                                Navigator.pop(context);
                                                                                await context.read<TurmasStateDesktop>().getTurmas(context);
                                                                              },
                                                                  )
                                                                ]),
                                                          ),
                                                        );
                                                      })
                                                    : AlertDialog(
                                                        content: Container(
                                                          child: const Text(
                                                            "Você já atingiu o limite de turmas!",
                                                            style: labelDark,
                                                          ),
                                                        ),
                                                      ));
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: primaryDark,
                                  ))
                            ]));
                      }),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.help,
                              color: primaryDark,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/ajuda");
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.person,
                              color: primaryDark,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/perfil");
                            },
                          ),
                        ],
                      )
                    ],
                  )
                : Row(
                    children: [
                      Consumer<TurmasStateDesktop>(
                          builder: (context, turmas, _) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                              color: primaryDark,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12))),
                          child: DropdownButton<Turma?>(
                              borderRadius: BorderRadius.circular(12),
                              dropdownColor: primaryDark,
                              underline: Container(),
                              value: turmas.turmaAtual,
                              items: [
                                const DropdownMenuItem(
                                    child: Text("Todos"), value: null),
                                ...turmas.turmas.map((e) => DropdownMenuItem(
                                      child: Text(e.nome),
                                      value: e,
                                    ))
                              ],
                              onChanged: (novoValor) {
                                turmas.changeTurmaAtual(novoValor);
                              }),
                        );
                      })
                    ],
                  ))
      ],
    );
  }
}
