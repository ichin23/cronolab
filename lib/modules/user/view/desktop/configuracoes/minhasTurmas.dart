import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/modules/turmas/view/desktop/editarTurma.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MinhasTurmasDesktop extends StatefulWidget {
  const MinhasTurmasDesktop({Key? key}) : super(key: key);

  @override
  State<MinhasTurmasDesktop> createState() => _MinhasTurmasDesktopState();
}

class _MinhasTurmasDesktopState extends State<MinhasTurmasDesktop> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Consumer<TurmasStateDesktop>(
        builder: (context, cont, child) => ListView.builder(
          controller: ScrollController(),
          itemCount: cont.turmas.length,
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
                                    await Provider.of<TurmasStateDesktop>(
                                            context)
                                        .deleteTurma(cont.turmas[i].id);

                                    Provider.of<TurmasStateDesktop>(context)
                                        .getTurmas(context)
                                        .then((value) => setState(() {}));
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
                if (cont.turmas[i].isAdmin) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              EditarTurmaDesktop(cont.turmas[i]))));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text("Erro"),
                            content:
                                Text("Você não é um administrador dessa turma"),
                          ));
                }
              },
              title: Text(
                cont.turmas[i].nome,
                style: labelDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
