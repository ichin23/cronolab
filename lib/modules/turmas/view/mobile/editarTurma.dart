import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/view/mobile/gerenciarAdmins.dart';
import 'package:cronolab/shared/colors.dart' as color;
import 'package:cronolab/shared/components/myInput.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../materia/view/mobile/editarMateria.dart';
import '../../turma.dart';

class EditarTurma extends StatefulWidget {
  EditarTurma(this.turma, {Key? key}) : super(key: key);
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
  late Turma turma;
  late Turmas turmas;
  bool privada = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    turmas = GetIt.I.get<Turmas>();
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
      codigo.text = turma.id.toString();
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
              "Matérias (${turmas.getMateriasFromTurma(turma).length}/${10})",
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
                  turma.materia.isNotEmpty
                      ? ListView.builder(
                          itemCount: turma.materia.length,
                          itemBuilder: (context, i) => ListTile(
                              onTap: () async {
                                Materia? newMateria = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarMateria(
                                            turma.materia[i],
                                            turma.id.toString())));
                                // context
                                //     .read<Turmas>()
                                //     .updateMateria(turma.id, newMateria);
                                if (newMateria != null) {
                                  turma.materia[i] = newMateria;
                                  setState(() {});
                                }
                              },
                              leading: IconButton(
                                  icon: Icon(Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error),
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
                                  if (turma.materia.length < 10) {
                                    /*addMateria(context, turma.id, () {})
                                        .then((value) async {
                                      await context.read<Turmas>().getData();
                                      // await turmas.getTurmas();
                                      turma = context
                                          .read<Turmas>()
                                          .getTurmaByID(turma.id)!;

                                      setState(() {});
                                    });*/
                                    setState(() {});
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const AlertDialog(
                                              content: Text(
                                                  "Você atingiu o limite de matérias nessa turma",
                                                  style: labelDark),
                                            ));
                                  }
                                },
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.add)))
                ],
              ),
            ),
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
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: color.whiteColor),
            ),
            const SizedBox(height: 15),
            /*Row(
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
                            // await turmas.deleteTurma(turma.id);
                            await turma.sairTurma();

                            // await turmas.getTurmas();

                            setState(() {
                              excluindo = false;
                            });
                            Navigator.pop(context);
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
                      Navigator.pop(context);
                    },
                    child: Text("Salvar",
                        style: Theme.of(context).textTheme.headlineMedium)),
              ],
            )*/
            // : Container()
          ]),
        ),
      ),
    );
  }
}
