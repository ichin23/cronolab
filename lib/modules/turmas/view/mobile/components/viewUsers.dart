import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';

import '../../../turma.dart';

class ViewUsers extends StatefulWidget {
  ViewUsers(this.turma, this.admins, this.participantes, this.refresh,
      {Key? key})
      : super(key: key);
  Turma turma;
  List participantes;
  List admins;
  Function refresh;

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  @override
  Widget build(BuildContext context) {
    return widget.participantes.isNotEmpty
        ? ListView.builder(
            itemCount: widget.participantes.length,
            itemBuilder: (context, i) => ListTile(
                  title: Text(
                    widget.participantes[i]["nome"] ??
                        widget.participantes[i]["id"],
                    style: labelDark,
                  ),
                  trailing: widget.admins
                          .where((element) =>
                              element["id"] == widget.participantes[i]["id"])
                          .toList()
                          .isNotEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.add),
                          color: primaryDark,
                          onPressed: () async {
                            if (widget.admins.length >= 3) {
                              await showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                        title: Text("Não é possível adicionar"),
                                        content: Text(
                                            "A turma já atingiu o limite de 3 administradores!"),
                                      ));
                              return;
                            }
                            await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          "Tem certeza que quer adicionar ${widget.participantes[i]['id']} como administrador da turma ${widget.turma.nome}?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              //print("OK");
                                              /*await context
                                            .read<Turmas>()
                                            .turmasFB
                                            .addAdmin(
                                                widget.participantes[i]["id"],
                                                widget.turma);*/

                                              widget.refresh();
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Sim"))
                                      ],
                                    ));
                          },
                        ),
                ))
        : const Text("Sem Participantes");
  }
}
