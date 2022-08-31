import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/minhasTurmas.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/novaSenha.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/suasInfos.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilPageDesktop extends StatefulWidget {
  const PerfilPageDesktop({Key? key}) : super(key: key);

  @override
  State<PerfilPageDesktop> createState() => _PerfilPageDesktopState();
}

class _PerfilPageDesktopState extends State<PerfilPageDesktop> {
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
      backgroundColor: black,
      appBar: AppBar(
        toolbarHeight: 55,
      ),
      body: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              width: size.width * 0.15,
              child: ListView.builder(
                  itemCount: pages.length,
                  itemBuilder: (context, i) => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor:
                              index == i ? pretoClaro : Colors.transparent,
                          onTap: () {
                            setState(() {
                              index = i;
                            });
                          },
                          title: Text(
                            pages.keys.toList()[i],
                            style: label,
                          ),
                        ),
                      ))),
          const RotatedBox(quarterTurns: 1, child: Divider()),
          Expanded(child: pages.values.toList()[index])
        ],
      ),
      floatingActionButton: index == 1
          ? FloatingActionButton(
              isExtended: true,
              onPressed: () {
                Get.dialog(AlertDialog(
                  backgroundColor: black,
                  title: const Text("Entrar na turma"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onSubmitted: (value) async {
                          await TurmasState.to.initTurma(value);
                          TurmasState.to
                              .getTurmas()
                              .then((value) => setState(() {}));
                          Get.back();
                        },
                      )
                    ],
                  ),
                ));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
