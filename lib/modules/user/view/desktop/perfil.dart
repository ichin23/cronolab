import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/minhasTurmas.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/novaSenha.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/suasInfos.dart';
import 'package:cronolab/shared/components/myInput.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilPageDesktop extends StatefulWidget {
  const PerfilPageDesktop({Key? key}) : super(key: key);

  @override
  State<PerfilPageDesktop> createState() => _PerfilPageDesktopState();
}

class _PerfilPageDesktopState extends State<PerfilPageDesktop> {
  final TextEditingController _turmaCode = TextEditingController();
  bool open = false;
  var index = 0;
  var pages = {
    "Minha conta": const SuasInfosDesktop(),
    "Minhas turmas": const MinhasTurmasDesktop(),
    "Alterar senha": const AlteraSenha(),
  };
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
      ),
      body: GetBuilder<TurmasStateDesktop>(
        builder: (turmas) => Row(
          children: [
            Column(
              children: [
                Container(
                    height: size.height * 0.85,
                    padding: const EdgeInsets.all(8),
                    width: size.width * 0.15,
                    child: ListView.builder(
                        itemCount: pages.length,
                        itemBuilder: (context, i) => MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                tileColor: index == i
                                    ? Theme.of(context).hoverColor
                                    : Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    index = i;
                                  });
                                },
                                title: Text(
                                  pages.keys.toList()[i],
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ))),
                Container(
                    child: TextButton(
                  child: const Text("Sair"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Get.back();
                  },
                ))
              ],
            ),
            const RotatedBox(quarterTurns: 1, child: Divider()),
            Expanded(child: pages.values.toList()[index])
          ],
        ),
      ),
      floatingActionButton: index == 1
          ? FloatingActionButton(
              isExtended: true,
              onPressed: () {
                Get.dialog(StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text("Entrar na turma",
                        style: Theme.of(context).textTheme.titleMedium),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyField(
                          nome: _turmaCode,
                          label: const Text("Código da turma"),
                        ),
                        TextButton(
                            onPressed: () async {
                              await TurmasStateDesktop.to
                                  .initTurma(_turmaCode.text, context);

                              await TurmasStateDesktop.to
                                  .getTurmas()
                                  .then((value) => setState(() {}));
                              Get.back();
                              _turmaCode.text = "";
                            },
                            child: const Text("Entrar"))
                      ],
                    ),
                  );
                }));
              },
              child: TurmasStateDesktop.to.loading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.add),
            )
          : null,
    );
  }
}
