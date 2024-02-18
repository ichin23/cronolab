import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/materia/view/mobile/addMateria.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/view/mobile/gerenciarAdmins.dart';
import 'package:cronolab/shared/colors.dart' as color;
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/components/myInput.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:cronolab/shared/models/settings.dart' as sett;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  late TurmasServer turmas;
  List<Materia> materias = [];
  bool privada = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    turma = widget.turma;
    turmas = GetIt.I.get<TurmasServer>();
    materias = turmas.getMateriasFromTurma(turma);
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
      setState(() {});
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
        backgroundColor: Colors.transparent,
        title: Text(
          "Gerenciar ${turma.nome}",
          style: const TextStyle(color: primaryDark),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: primaryDark,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.3,
                child: Stack(
                  children: [
                    Column(children: [
                      const SizedBox(height: 38),
                      MyField(
                          nome: nome,
                          onChanged: (val) {
                            setState(() {});
                          },
                          label: const Text("Nome")),
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
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
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
                              child: MyField(
                                  nome: senha, label: const Text("Senha")))
                          : Container(),
                      const SizedBox(height: 15),

                      const SizedBox(height: 15),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GerenciarAdmins(turma)));
                        },
                        tileColor: color.whiteColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: Text("Administradores",
                            style: Theme.of(context).textTheme.labelMedium),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: color.whiteColor),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: size.width * 0.3 - 30,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            GetIt.I
                                .get<TurmasServer>()
                                .sairTurma(context, turma.id);
                          },
                          child: const Text(
                            "Sair",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w700),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                      color: Colors.red, width: 2))),
                        ),
                      )
                      // : Container()
                    ]),
                    Visibility(
                      visible: nome.text != widget.turma.nome &&
                          nome.text.isNotEmpty,
                      child: Positioned(
                          bottom: 10,
                          right: 10,
                          child: FloatingActionButton(
                            onPressed: () {},
                            child: const Icon(Icons.check),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Matérias (" + materias.length.toString() + "/10)",
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
                            materias.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemCount: materias.length,
                                      itemBuilder: (context, i) => ListTile(
                                          onTap: () async {
                                            Materia? newMateria =
                                                await editarMateria(context,
                                                    materias[i], turma);
                                            materias = GetIt.I
                                                .get<TurmasServer>()
                                                .getMateriasFromTurma(turma);

                                            if (newMateria == null) return;
                                            /*context
                                                .read<TurmasStateDesktop>()
                                                .updateMateria(
                                                    turma.id, newMateria);*/

                                            materias[i] = newMateria;
                                            setState(() {});
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          trailing: Icon(Icons.edit,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          title: Text(materias[i].nome,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium)),
                                    ),
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
                                            if (turma.materia.length < 10) {
                                              addMateria(
                                                      context,
                                                      turma.id.toString(),
                                                      () {})
                                                  .then((value) async {
                                                materias =
                                                    turmas.getMateriasFromTurma(
                                                        turma);

                                                setState(() {});
                                              });

                                              setState(() {});
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const AlertDialog(
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

Future<Materia?> editarMateria(
    BuildContext context, Materia materia, Turma turma) async {
  TextEditingController nome = TextEditingController();
  TextEditingController prof = TextEditingController();
  TextEditingController cont = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  nome.text = materia.nome;
  prof.text = materia.prof ?? "";
  cont.text = materia.contato ?? "";

  bool loading = false;
  Materia? valueReturn = materia;

  await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
            return Dialog(
              backgroundColor: backgroundDark,
              insetPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Editar Matéria: ${materia.nome}",
                            style: labelDark,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                              maxLength: 50,
                              controller: nome,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Digite um valor";
                                }
                                return null;
                              },
                              style: labelDark,
                              decoration: InputDecoration(
                                  counterText: "",
                                  label: const Text("Nome"),
                                  icon: const Icon(Icons.border_color,
                                      color: whiteColor),
                                  labelStyle: inputDark,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ))),
                          const SizedBox(height: 10),
                          TextFormField(
                              maxLength: 50,
                              controller: prof,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Digite um valor";
                                }
                                return null;
                              },
                              style: labelDark,
                              decoration: InputDecoration(
                                  counterText: "",
                                  label: const Text("Professor"),
                                  icon: const Icon(Icons.person,
                                      color: whiteColor),
                                  labelStyle: inputDark,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ))),
                          const SizedBox(height: 10),
                          TextFormField(
                              maxLength: 50,
                              controller: cont,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Digite um valor";
                                }
                                return null;
                              },
                              style: labelDark,
                              decoration: InputDecoration(
                                  counterText: "",
                                  label: const Text("Contato"),
                                  icon: const Icon(Icons.contact_page,
                                      color: whiteColor),
                                  labelStyle: inputDark,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ))),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              loading
                                  ? const CircularProgressIndicator()
                                  : Container(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        setstate(() {
                                          loading = true;
                                        });
                                        await GetIt.I
                                            .get<TurmasServer>()
                                            .deleteMateria(materia);
                                        await GetIt.I
                                            .get<TurmasServer>()
                                            .getData();

                                        setstate(() {
                                          loading = false;
                                          valueReturn = null;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Excluir",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        if (_form.currentState!.validate()) {
                                          materia.nome = nome.text;
                                          materia.prof = prof.text;
                                          materia.contato = cont.text;

                                          setstate(() {
                                            loading = true;
                                          });
                                          GetIt.I
                                              .get<TurmasServer>()
                                              .editarMateria(materia);
                                          /* await FirebaseFirestore.instance
                                              .collection("turmas")
                                              .doc(turma.id)
                                              .collection("materias")
                                              .doc(materia.id)
                                              .update({
                                            "professor": prof.text,
                                            "nome": nome.text,
                                            "contato": cont.text,
                                          });*/

                                          setstate(() {
                                            loading = false;
                                            valueReturn = materia;
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Salvar")),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }));
  return valueReturn;
}
