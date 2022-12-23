import 'package:cronolab/modules/materia/view/mobile/addMateria.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart' as color;
import 'package:cronolab/shared/components/myInput.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../materia/view/mobile/editarMateria.dart';
import '../../turma.dart';

class EditarTurma extends StatefulWidget {
  const EditarTurma({Key? key}) : super(key: key);

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
  var turma = Get.arguments as Turma;
  bool privada = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: 100, end: 0).animate(controller)
      ..addStatusListener((status) {
        setState(() {});
      })
      ..addListener(() {
        setState(() {});
      });
    nome.text = turma.nome;
    codigo.text = turma.id;
    // controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var turmas = TurmasLocal.to;
    var turmasState = TurmasState.to;
    // widget.turma.materias.add("");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gerenciar ${turma.nome}",
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(children: [
            MyField(nome: nome, label: const Text("Nome")),
            const SizedBox(height: 15),
            MyField(
              nome: codigo,
              label: const Text("Código"),
              editable: false,
            ),
            Visibility(
              visible: false,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Privada",
                        style: Theme.of(context).textTheme.labelMedium),
                    Switch(
                        activeColor: Theme.of(context).primaryColor,
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
            ),
            privada &&
                    (animation.status != AnimationStatus.forward ||
                        animation.status != AnimationStatus.reverse)
                ? Container(
                    // opacity: privada ? 1 : 0,
                    // decoration: BoxDecoration(),
                    margin: EdgeInsets.only(right: animation.value),
                    child: MyField(nome: senha, label: const Text("Senha")))
                : Container(),
            const SizedBox(height: 15),
            Text(
              "Matérias",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 15),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: color.whiteColor.withOpacity(0.1),
              ),
              child: Stack(
                children: [
                  turma.materias.isNotEmpty
                      ? ListView.builder(
                          itemCount: turma.materias.length,
                          itemBuilder: (context, i) => ListTile(
                              onTap: () {
                                editaMateria(context, turma.materias[i], turma,
                                    () => setState(() {}));
                              },
                              leading: IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Theme.of(context).errorColor),
                                  onPressed: loading
                                      ? null
                                      : () async {
                                          setState(() {
                                            loading = true;
                                          });
                                          await turma.deleteMateria(
                                              turma.materias[i].id);
                                          await TurmasLocal.to.deleteMateria(
                                              turma.materias[i].id);
                                          await TurmasLocal.to
                                              .getTurmas(updateTurma: false);
                                          TurmasLocal.to
                                              .changeTurmaAtualWithID(turma.id);
                                          turma = TurmasLocal.to.turmaAtual!;
                                          debugPrint(
                                              turma.materias.length.toString());
                                          // widget.turma.materias
                                          //     .remove(widget.turma.materias[i]);
                                          setState(() {
                                            loading = false;
                                          });
                                        }),
                              title: Text(turma.materias[i].nome,
                                  style:
                                      Theme.of(context).textTheme.labelMedium)),
                        )
                      : Center(
                          child: Text(
                            "Nada foi encontrado",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                          onPressed: loading
                              ? null
                              : () {
                                  TextEditingController materia =
                                      TextEditingController();

                                  addMateria(context, turma.id, () async {
                                    await turmasState.getTurmas();
                                    await turmas.getTurmas();
                                    turma = await turmas.getByID(turma.id);

                                    setState(() {});
                                  });
                                  setState(() {});
                                },
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.add)))
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xffF2A299))),
                    onPressed: excluindo
                        ? null
                        : () async {
                            setState(() {
                              excluindo = true;
                            });
                            await turmas.deleteTurma(turma.id);
                            await turma.sairTurma();

                            await turmas.getTurmas();

                            setState(() {
                              excluindo = false;
                            });
                            Get.back();
                          },
                    child: excluindo
                        ? const CircularProgressIndicator()
                        : Text("Excluir",
                            style: Theme.of(context).textTheme.headlineMedium)),
                TextButton(
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    onPressed: () async {
                      Get.back();
                    },
                    child: Text("Salvar",
                        style: Theme.of(context).textTheme.headlineMedium)),
              ],
            )
            // : Container()
          ]),
        ),
      ),
    );
  }
}
