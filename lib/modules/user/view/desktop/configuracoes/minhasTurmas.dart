import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinhasTurmasDesktop extends StatefulWidget {
  const MinhasTurmasDesktop({Key? key}) : super(key: key);

  @override
  State<MinhasTurmasDesktop> createState() => _MinhasTurmasDesktopState();
}

class _MinhasTurmasDesktopState extends State<MinhasTurmasDesktop> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TurmasStateDesktop>(
      builder: (cont) => ListView.builder(
        controller: ScrollController(),
        itemCount: cont.turmas.length,
        itemBuilder: (context, i) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ListTile(
            trailing: IconButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  title: const Text("Excluir"),
                  content: const Text("Deseja excluir essa turma?"),
                  actions: [
                    TextButton(onPressed: () {}, child: const Text("Não")),
                    TextButton(
                        onPressed: () async {
                          Get.back();
                          await TurmasStateDesktop.to
                              .deleteTurma(cont.turmas[i].id);

                          TurmasStateDesktop.to
                              .getTurmas()
                              .then((value) => setState(() {}));
                        },
                        child: const Text("Sim"))
                  ],
                ));
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () {
              if (cont.turmas[i].isAdmin) {
              } else {
                Get.dialog(const AlertDialog(
                  title: Text("Erro"),
                  content: Text("Você não é um administrador dessa turma"),
                ));
              }
            },
            title: Text(
              cont.turmas[i].nome,
              style: label,
            ),
          ),
        ),
      ),
    );
  }
}
