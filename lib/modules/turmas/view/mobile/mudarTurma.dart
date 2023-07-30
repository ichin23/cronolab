import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MudarTurma extends StatefulWidget {
  const MudarTurma({super.key});

  @override
  State<MudarTurma> createState() => _MudarTurmaState();
}

class _MudarTurmaState extends State<MudarTurma> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Trocar turma"),
      ),
      body: SafeArea(

        child: Consumer<Turmas>(
          builder: (context, turmas, _)=>Container(
            padding: EdgeInsets.symmetric (vertical: 10),
            child: ListView(children: [

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
                  .toList(),
            ]),
          ),
        ),
      ),
    );
  }
}
