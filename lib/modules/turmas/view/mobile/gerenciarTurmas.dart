import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:cronolab/shared/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GerenciarTurmas extends StatefulWidget {
  const GerenciarTurmas({Key? key}) : super(key: key);

  @override
  State<GerenciarTurmas> createState() => _GerenciarTurmasState();
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class _GerenciarTurmasState extends State<GerenciarTurmas> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: darkPrimary,
      systemNavigationBarColor: darkPrimary,
    ));
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Turmas"),
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
          child: Consumer<Turmas>(
              builder: (context, turmas, child) =>
                   ListView.builder(
            itemCount: turmas.turmasSQL.turmas.length,
            itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: ListTile(
                      onTap: () async {
                        if (turmas.turmasSQL.turmas[i].isAdmin) {
                          await Navigator.of(context)
                              .pushNamed('/turma', arguments: turmas.turmasSQL.turmas[i]);
                        } else {
                          await showModalBottomSheet(
                              context: context,
                              builder: (context) => BottomSheet(
                                  onClosing: () {},
                                  builder: (context) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: backgroundDark,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "Excluir",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            trailing: Icon(
                                              Icons.delete,
                                              color:
                                                  Theme.of(context).errorColor,
                                            ),
                                            onTap: () async {
                                              // await turmas.turmasSQL.turmas[i]
                                              //     .sairTurma();
                                              await turmas.turmasSQL.deleteTurma(
                                                  turmas.turmasSQL.turmas[i]);

                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }));
                          // Get.dialog(
                          //   const AlertDialog(
                          //     backgroundColor: black,
                          //     title: Text(
                          //       "Erro ao acessar",
                          //       style: TextStyle(color: white),
                          //     ),
                          //     content: Text(
                          //         "Você não é administrador dessa turma",
                          //         style: TextStyle(color: white)),
                          //   ),
                          // );
                        }
                        turmas.getData().then((value) => setState(() {}));
                      },
                      trailing: const Icon(
                        Icons.settings,
                        //color: whiteColor,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: Theme.of(context).hoverColor.withOpacity(0.1),
                      title: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(turmas.turmasSQL.turmas[i].nome.toTitleCase(),
                              style: Theme.of(context).textTheme.labelMedium))),
                )),
              )),
      floatingActionButton: FloatingActionButton(
          onPressed: loading
              ? null
              : () {
                  TextEditingController code = TextEditingController();
                  showDialog(
                      context: context,
                      builder: (context) => context.read<Turmas>().turmasSQL.turmas.length< context.read<Settings>().limTurmas? StatefulBuilder(
                            builder: (context, setstate) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Text("Adicionar Turma",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Digite o código da turma",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  const SizedBox(height: 15),
                                  TextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                    decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: whiteColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: darkPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: whiteColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    controller: code,
                                    onSubmitted: (value) {},
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(20)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  darkPrimary),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)))),
                                      onPressed: loading
                                          ? null
                                          : () async {
                                              loading = true;
                                              setstate(() {});

                                              await context.read<Turmas>().turmasSQL.createTurma(Turma(nome: code.text, id: code.text)..setAdmin());
                                              await context.read<Turmas>().turmasFB.createTurma(Turma(nome: code.text, id: code.text)..setAdmin());
                                              await context.read<Turmas>().getData();



                                              Navigator.pop(context);
                                              setState(() {loading=false;});
                                            },
                                      child: loading
                                          ? CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .backgroundColor)
                                          : const Text("Adicionar",
                                              style:
                                                  TextStyle(color: whiteColor)))
                                ],
                              ),
                            ),
                          ): AlertDialog(
                        content: Container(
                          child: const Text(
                            "Você já atingiu o limite de turmas!",
                            style: labelDark,
                          ),
                        ),
                      ));
                },
          child: loading
              ? CircularProgressIndicator(
                  color: Theme.of(context).backgroundColor,
                )
              : Icon(
                  Icons.add,
                  color: Theme.of(context).backgroundColor,
                  size: 40,
                )),
      // );
      // }
    );
  }
}
