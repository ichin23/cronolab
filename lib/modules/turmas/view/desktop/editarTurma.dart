import 'package:cronolab/modules/materia/view/mobile/addMateria.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/modules/turmas/view/mobile/gerenciarAdmins.dart';
import 'package:cronolab/shared/colors.dart' as color;
import 'package:cronolab/shared/components/myInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../materia/view/mobile/editarMateria.dart';
import '../../turma.dart';

class EditarTurmaDesktop extends StatefulWidget {
  EditarTurmaDesktop(this.turma, {Key? key}) : super(key: key);
  Turma turma;

  @override
  State<EditarTurmaDesktop> createState() => _EditarTurmaDesktopState();
}

class _EditarTurmaDesktopState extends State<EditarTurmaDesktop>
    with SingleTickerProviderStateMixin {
  TextEditingController nome = TextEditingController();
  TextEditingController codigo = TextEditingController();
  TextEditingController senha = TextEditingController();
  late Animation animation;
  late AnimationController controller;
  bool excluindo = false;
  late Turma turma;
  bool privada = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    turma = widget.turma;
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: 100, end: 0).animate(controller)
      ..addStatusListener((status) {
        setState(() {});
      })
      ..addListener(() {
        setState(() {});
      });
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      nome.text = turma.nome;
      codigo.text = turma.id;
    });
    // controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gerenciar ${turma.nome}",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.3,
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
                          child:
                              MyField(nome: senha, label: const Text("Senha")))
                      : Container(),
                  const SizedBox(height: 15),

                  const SizedBox(height: 15),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GerenciarAdmins(turma)));
                    },
                    tileColor: color.whiteColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Text("Administradores",
                        style: Theme.of(context).textTheme.labelMedium),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: color.whiteColor),
                  ),
                  const SizedBox(height: 15),

                  // : Container()
                ]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Matérias",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: color.whiteColor.withOpacity(0.1),
                        ),
                        child: Stack(
                          children: [
                            turma.materia.isNotEmpty
                                ? ListView.builder(
                                    itemCount: turma.materia.length,
                                    itemBuilder: (context, i) => ListTile(
                                        onTap: () {
                                          editaMateria(
                                              context,
                                              turma.materia[i],
                                              turma,
                                              () => setState(() {}));
                                        },
                                        leading: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                            onPressed: loading
                                                ? null
                                                : () async {
                                                    //TODO setState(() {
                                                    //   loading = true;
                                                    // });
                                                    // await turma.deleteMateria(
                                                    //     turma.materias[i].id);
                                                    // await Provider.of<TurmasLocal>(
                                                    //         context)
                                                    //     .deleteMateria(
                                                    //         turma.materias[i].id);
                                                    // await Provider.of<TurmasLocal>(
                                                    //         context)
                                                    //     .getTurmas(updateTurma: false);
                                                    // Provider.of<TurmasLocal>(context)
                                                    //     .changeTurmaAtualWithID(turma.id);
                                                    // turma =
                                                    //     Provider.of<TurmasLocal>(context)
                                                    //         .turmaAtual!;
                                                    // debugPrint(
                                                    //     turma.materias.length.toString());
                                                    // // widget.turma.materias
                                                    // //     .remove(widget.turma.materias[i]);
                                                    // setState(() {
                                                    //   loading = false;
                                                    // });
                                                  }),
                                        title: Text(turma.materia[i].nome,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium)),
                                  )
                                : Center(
                                    child: Text(
                                      "Nada foi encontrado",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
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

                                            addMateria(context, turma.id, () {})
                                                .then((value) async {
                                              var newTurma = await context
                                                  .read<TurmasStateDesktop>()
                                                  .refreshTurma(turma.id);
                                              if (newTurma != null) {
                                                turma = newTurma;
                                              }
                                              setState(() {});
                                            });
                                            context
                                                .read<TurmasStateDesktop>()
                                                .getTurmas(context);
                                            setState(() {});
                                          },
                                    child: loading
                                        ? const CircularProgressIndicator()
                                        : const Icon(Icons.add)))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
