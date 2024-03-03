import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MudarTurma extends StatefulWidget {
  const MudarTurma({super.key});

  @override
  State<MudarTurma> createState() => _MudarTurmaState();
}

class _MudarTurmaState extends State<MudarTurma> {
  var turmas = GetIt.I.get<TurmasServer>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Trocar turma"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(children: [
            ...turmas.turmas.value
                .map((turma) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: RadioListTile<String>(
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: turma.id,
                          groupValue: turmas.turmaAtual.value?.id,
                          onChanged: (val) async {
                            //await turmas.changeTurmaAtual(turma);
                            await turmas.getData();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          tileColor: Theme.of(context).hoverColor,
                          selectedTileColor:
                              Theme.of(context).colorScheme.secondary,
                          activeColor: Theme.of(context).colorScheme.primary,
                          title: Text(
                            turma.nome,
                            style: const TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                    ))
                .toList(),
          ]),
        ),
      ),
    );
  }
}
