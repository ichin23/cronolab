import 'package:cronolab/modules/materia/view/addMateria.dart';
import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/shared/colors.dart' as color;
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:cronolab/shared/myInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../materia/view/editarMateria.dart';
import '../turma.dart';

class EditarTurma extends StatefulWidget {
  EditarTurma({Key? key, required this.turma}) : super(key: key);
  Turma turma;

  @override
  State<EditarTurma> createState() => _EditarTurmaState();
}

class _EditarTurmaState extends State<EditarTurma>
    with SingleTickerProviderStateMixin {
  TextEditingController nome = TextEditingController();
  TextEditingController codigo = TextEditingController();
  TextEditingController senha = TextEditingController();
  late Animation animation;
  late AnimationController controller;
  bool excluindo = false;

  bool privada = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: 100, end: 0).animate(controller)
      ..addStatusListener((status) {
        print(status);
        setState(() {});
      })
      ..addListener(() {
        setState(() {});
      });
    nome.text = widget.turma.nome;
    codigo.text = widget.turma.id;
    // controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var turmas = Provider.of<TurmasProvider>(context);
    // widget.turma.materias.add("");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gerenciar ${widget.turma.nome}",
        ),
        backgroundColor: darkPrimary,
      ),
      backgroundColor: color.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(children: [
            MyField(nome: nome, label: const Text("Nome")),
            const SizedBox(height: 15),
            MyField(nome: codigo, label: const Text("Código")),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Privada", style: label),
              Switch(
                  activeColor: color.primary,
                  value: privada,
                  onChanged: (value) {
                    // controller.dispose();
                    if (value) {
                      controller.forward();
                    } else {
                      controller.reverse();
                    }
                    setState(() {
                      privada = value;
                    });
                  })
            ]),
            privada &&
                    (animation.status != AnimationStatus.forward ||
                        animation.status != AnimationStatus.reverse)
                ? Container(
                    // opacity: privada ? 1 : 0,
                    // decoration: BoxDecoration(),
                    margin: EdgeInsets.only(right: animation.value),
                    child: MyField(nome: senha, label: Text("Senha")))
                : Container(),
            const SizedBox(height: 15),
            Text(
              "Matérias",
              style: label,
            ),
            const SizedBox(height: 15),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: color.white.withOpacity(0.1),
              ),
              child: Stack(
                children: [
                  widget.turma.materias.isNotEmpty
                      ? ListView.builder(
                          itemCount: widget.turma.materias.length,
                          itemBuilder: (context, i) => ListTile(
                              onTap: () {
                                editaMateria(
                                    context,
                                    widget.turma.materias[i],
                                    widget.turma,
                                    turmas,
                                    () => setState(() {}));
                              },
                              leading: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: color.red),
                                  onPressed: () {
                                    // widget.turma.materias
                                    //     .remove(widget.turma.materias[i]);
                                    setState(() {});
                                  }),
                              title: Text(widget.turma.materias[i].nome,
                                  style: label)),
                        )
                      : Center(
                          child: Text(
                            "Nada foi encontrado.......",
                            style: label,
                          ),
                        ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                          onPressed: () {
                            TextEditingController materia =
                                TextEditingController();
                            bool loading = false;
                            addMateria(context, widget.turma.id, () async {
                              await turmas.getTurmas();

                              setState(() {});
                            });
                            // showDialog(
                            //     context: context,
                            //     builder: (context) => StatefulBuilder(
                            //           builder: (context, setState) =>
                            //               AlertDialog(
                            //             title: Text("Adicionar Matéria",
                            //                 style: label),
                            //             backgroundColor: darkPrimary,
                            //             content: loading
                            //                 ? const CircularProgressIndicator()
                            //                 : Column(
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     children: [
                            //                       Text(
                            //                           "Digite o nome da matéria",
                            //                           style: label),
                            //                       const SizedBox(height: 10),
                            //                       MyField(
                            //                         nome: materia,
                            //                         label:
                            //                             const Text("Matéria"),
                            //                       ),
                            //                       TextButton(
                            //                           onPressed: () async {
                            //                             if (controller.value !=
                            //                                 null) {
                            //                               setState(() {
                            //                                 loading = true;
                            //                               });
                            //                               await widget.turma
                            //                                   .addMateria(
                            //                                       materia.text);
                            //                               setState(() {
                            //                                 loading = false;
                            //                               });
                            //                               Navigator.pop(
                            //                                   context);
                            //                             }
                            //                           },
                            //                           child: Text("Adicionar"))
                            //                     ],
                            //                   ),
                            //           ),
                            //         ));
                            setState(() {});
                          },
                          child: Icon(Icons.add)))
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffF2A299))),
                    onPressed: excluindo
                        ? null
                        : () async {
                            setState(() {
                              excluindo = true;
                            });
                            await widget.turma.deleteTurma();
                            Navigator.pop(context);
                            await turmas.getTurmas();
                            setState(() {
                              excluindo = false;
                            });
                          },
                    child: excluindo
                        ? CircularProgressIndicator()
                        : Text("Excluir", style: buttonText)),
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStateProperty.all(primary)),
                    onPressed: () async {},
                    child: Text("Salvar", style: buttonText)),
              ],
            )
            // : Container()
          ]),
        ),
      ),
    );
  }
}
