import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAdmins extends StatefulWidget {
  ViewAdmins(this.turma, this.admins, this.refresh, {Key? key}) : super(key: key);
  Turma turma;
  List admins;
  Function refresh;

  @override
  State<ViewAdmins> createState() => _ViewAdminsState();
}

class _ViewAdminsState extends State<ViewAdmins> {
  @override
  Widget build(BuildContext context) {
    return widget.admins.isNotEmpty
        ? ListView.builder(
            itemCount: widget.admins.length,
            itemBuilder: (context, i) => ListTile(
                  title: Text(
                    widget.admins[i]["nome"] ?? widget.admins[i]["id"],
                    style: labelDark,
                  ),
              trailing: FirebaseAuth.instance.currentUser!.uid == widget.admins[i]["id"] ? null: IconButton(
                icon: Icon(Icons.remove),
                color: primaryDark,
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                            "Tem certeza que quer remover esse Administrador?"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                //print("OK");
                                await context
                                    .read<Turmas>()
                                    .turmasFB
                                    .removeAdmin(
                                    widget.admins[i]["id"],
                                    widget.turma);

                                widget.refresh();
                                Navigator.pop(context);
                              },
                              child: Text("Sim"))
                        ],
                      ));

                },
              ),
                ), )
        : Text("Sem Admins");

    ;
  }
}
