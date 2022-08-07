import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GerenciarTurmas extends StatefulWidget {
  const GerenciarTurmas({Key? key}) : super(key: key);

  @override
  State<GerenciarTurmas> createState() => _GerenciarTurmasState();
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
    TextEditingController code = TextEditingController();
    // var auth = Provider.of<Auth>(context);
    return
        // Consumer<TurmasProvider>(builder: (context, turmas, child) {
        //   // print(turmas.turmas);
        //   // List turmas = [];
        //   return
        Scaffold(
      backgroundColor: black,
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
        // actions: [
        //   loading
        //       ? Container(
        //           height: 20, width: 20, child: CircularProgressIndicator())
        //       : Container()
        // ],
      ),
      body: SafeArea(
          child: GetBuilder<TurmasLocal>(
        init: TurmasLocal.to,
        builder: (turmas) => ListView.builder(
            itemCount: turmas.turmas.length,
            itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                      onTap: () {
                        if (turmas.turmas[i].isAdmin) {
                          Get.toNamed('/turma', arguments: turmas.turmas[i]);
                        } else {
                          Get.dialog(
                            const AlertDialog(
                              backgroundColor: black,
                              title: Text(
                                "Erro ao acessar",
                                style: TextStyle(color: white),
                              ),
                              content: Text(
                                  "Você não é administrador dessa turma",
                                  style: TextStyle(color: white)),
                            ),
                          );
                        }
                      },
                      trailing: const Icon(
                        Icons.settings,
                        color: white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      tileColor: white.withOpacity(0.1),
                      title: Text(turmas.turmas[i].nome,
                          style: const TextStyle(color: white))),
                )),
      )),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: primary,
          onPressed: loading
              ? null
              : () {
                  Get.dialog(StatefulBuilder(
                    builder: (context, setstate) => AlertDialog(
                      backgroundColor: black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text("Adicionar Turma",
                          style: TextStyle(color: white)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Digite o código da turma",
                              style: TextStyle(color: white)),
                          const SizedBox(height: 15),
                          TextField(
                            style: fonts.input,
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: white),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: darkPrimary),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: primary),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: white),
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

                                      // print("AAAAAAAAAAAAAAAAAAAAA");
                                      await turmas.initTurma(code.text);

                                      // await turmas.enterTurma(code.text, context);
                                      turmas
                                          .getTurmas()
                                          .then((value) => setState(() {
                                                loading = false;
                                              }));

                                      Get.back();
                                      setState(() {});
                                    },
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: black)
                                  : const Text("Adicionar",
                                      style: TextStyle(color: white)))
                        ],
                      ),
                    ),
                  ));
                },
          child: loading
              ? const CircularProgressIndicator(
                  color: black,
                )
              : const Icon(
                  Icons.add,
                  color: black,
                  size: 40,
                )),
      // );
      // }
    );
  }
}
