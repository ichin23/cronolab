import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
    TurmasState turmas = TurmasState.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Turmas"),
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
          child: GetBuilder<TurmasLocal>(
        init: TurmasLocal.to,
        builder: (turmas) => ListView.builder(
            itemCount: turmas.turmas.length,
            itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: ListTile(
                      onTap: () async {
                        if (turmas.turmas[i].isAdmin) {
                          await Get.toNamed('/turma',
                              arguments: turmas.turmas[i]);
                        } else {
                          await Get.bottomSheet(BottomSheet(
                              onClosing: () {},
                              builder: (context) {
                                return Container(
                                  decoration: BoxDecoration(
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
                                          color: Theme.of(context).errorColor,
                                        ),
                                        onTap: () async {
                                          await turmas.turmas[i].sairTurma();
                                          await turmas
                                              .deleteTurma(turmas.turmas[i].id);

                                          Get.back();
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
                        turmas.getTurmas().then((value) => setState(() {}));
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
                          child: Text(turmas.turmas[i].nome.toTitleCase(),
                              style: Theme.of(context).textTheme.labelMedium))),
                )),
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: loading
              ? null
              : () {
                  TextEditingController code = TextEditingController();
                  Get.dialog(StatefulBuilder(
                    builder: (context, setstate) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Text("Adicionar Turma",
                          style: Theme.of(context).textTheme.bodyMedium),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Digite o código da turma",
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 15),
                          TextField(
                            style: Theme.of(context).textTheme.headlineSmall,
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: whiteColor),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: darkPrimary),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: whiteColor),
                                  borderRadius: BorderRadius.circular(10)),
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
                                      MaterialStateProperty.all(darkPrimary),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)))),
                              onPressed: loading
                                  ? null
                                  : () async {
                                      loading = true;
                                      setstate(() {});

                                      await turmas.initTurma(
                                          code.text, context);

                                      await turmas.getTurmas();

                                      TurmasLocal.to
                                          .getTurmas()
                                          .then((value) => setState(() {
                                                loading = false;
                                              }));

                                      Get.back();
                                      setState(() {});
                                    },
                              child: loading
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context).backgroundColor)
                                  : const Text("Adicionar",
                                      style: TextStyle(color: whiteColor)))
                        ],
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
