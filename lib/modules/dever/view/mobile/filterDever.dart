import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<List> filterDever({List? oldList}) async {
  final _cores = ["Vermelha", "Amarela", "Verde"];
  List<dynamic> list = oldList ?? List.generate(2, (index) => null);
  Materia? materiaSelect;
  print(list);
  int? corSelect;

  await Get.dialog(AlertDialog(
    backgroundColor: black,
    title: const Text(
      "Selecione o Filtro",
      style: inputDever,
    ),
    content: StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Cores",
            style: label,
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ..._cores
                    .map(
                      (cor) => GestureDetector(
                        onTap: () {
                          if (list[0] == _cores.indexOf(cor)) {
                            list[0] = null;
                            corSelect = null;
                          } else {
                            corSelect = _cores.indexOf(cor);
                            list[0] = corSelect;
                          }
                          setState(() {});
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: list[0] != null
                                    ? list[0] == _cores.indexOf(cor)
                                        ? primary2
                                        : Colors.transparent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: primary2,
                                )),
                            child: Text(cor, style: input)),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Matéria",
            style: label,
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...TurmasLocal.to.turmaAtual!.materias
                    .map((e) => GestureDetector(
                          onTap: () {
                            if (list[1] == e.id) {
                              materiaSelect = null;
                              list[1] = null;
                            } else {
                              materiaSelect = e;
                              list[1] = materiaSelect!.id;
                            }
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: list[1] != null
                                    ? list[1] == e.id
                                        ? primary2
                                        : Colors.transparent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: primary2,
                                )),
                            child: Text(
                              e.nome,
                              style: input,
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"))
        ],
      );
    }),
  ));
  return list;
}
