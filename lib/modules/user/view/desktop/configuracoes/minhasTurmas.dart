import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/view/desktop/editarTurma.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MinhasTurmasDesktop extends StatefulWidget {
  const MinhasTurmasDesktop({Key? key}) : super(key: key);

  @override
  State<MinhasTurmasDesktop> createState() => _MinhasTurmasDesktopState();
}

class _MinhasTurmasDesktopState extends State<MinhasTurmasDesktop> {
  late TurmasServer turmas;

  @override
  void initState() {
    turmas = GetIt.I.get<TurmasServer>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Stack(
        children: [
          ListView.builder(
            controller: ScrollController(),
            itemCount: turmas.turmas.value.length,
            itemBuilder: (context, i) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ListTile(
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Excluir"),
                              content: const Text("Deseja excluir essa turma?"),
                              actions: [
                                TextButton(
                                    onPressed: () {}, child: const Text("Não")),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      //TODO: deleteTurma

                                      turmas.getData();
                                    },
                                    child: const Text("Sim"))
                              ],
                            ));
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  if (turmas.turmas.value[i].isAdmin) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                EditarTurmaDesktop(turmas.turmas.value[i]))));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text("Erro"),
                              content: Text(
                                  "Você não é um administrador dessa turma"),
                            ));
                  }
                },
                title: Text(
                  turmas.turmas.value[i].nome,
                  style: labelDark,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child:
                  Container() /*FloatingActionButton(
                isExtended: true,
                onPressed: () {
                  TextEditingController _turmaCode = TextEditingController();
                  showDialog(
                      context: context,
                      builder: (context) => context
                                  .read<TurmasStateDesktop>()
                                  .turmas
                                  .length <
                              context.read<Settings>().limTurmas
                          ? StatefulBuilder(builder: (context, setState) {
                              return AlertDialog(
                                title: Text("Entrar na turma",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MyField(
                                      nome: _turmaCode,
                                      label: const Text("Código da turma"),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          await Provider.of<TurmasStateDesktop>(
                                                  context)
                                              .initTurma(
                                                  _turmaCode.text, context);

                                          await Provider.of<TurmasStateDesktop>(
                                                  context)
                                              .getTurmas(context)
                                              .then((value) => setState(() {}));
                                          Navigator.pop(context);
                                          _turmaCode.text = "";
                                        },
                                        child: const Text("Entrar"))
                                  ],
                                ),
                              );
                            })
                          : const AlertDialog(
                              content: Text(
                                "Você já atingiu o limite de turmas!",
                                style: labelDark,
                              ),
                            ));
                },
                child: Provider.of<TurmasStateDesktop>(context).loading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.add),
              )*/
              )
        ],
      ),
    );
  }
}
