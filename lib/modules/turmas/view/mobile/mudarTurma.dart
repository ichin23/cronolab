import 'package:flutter/material.dart';

class MudarTurma extends StatefulWidget {
  const MudarTurma({super.key});

  @override
  State<MudarTurma> createState() => _MudarTurmaState();
}

class _MudarTurmaState extends State<MudarTurma> {
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
          child: ListView(children: const [
/*
              ...context
                  .watch<Turmas>()
                  .turmasSQL
                  .turmas
                  .map((turma) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12, vertical: 8),
                    child: RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      value:  turma.id,
                      groupValue: turmas.turmaAtual?.id,
                      onChanged: (val)async{
                        await turmas.changeTurmaAtual(turma);
                        await turmas.getDeveres();
                        setState(() {

                        });
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: Theme.of(context)
                        .hoverColor,
                        selectedTileColor: Theme.of(context).colorScheme.secondary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    title: Text(
                      turma.nome,
                      style:
                      TextStyle(color:   whiteColor, fontWeight: FontWeight.w500,),
                    )),
                  ))
                  .toList(),*/
          ]),
        ),
      ),
    );
  }
}
