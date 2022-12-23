import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<List> filterDever(BuildContext context, {List? oldList}) async {
  final _cores = ["Vermelha", "Amarela", "Verde"];
  List<dynamic> list = oldList ?? List.generate(2, (index) => null);
  Materia? materiaSelect;
  debugPrint(list.toString());
  int? corSelect;

  await Get.dialog(AlertDialog(
    title: Text(
      "Selecione o Filtro",
      style: Theme.of(context).textTheme.labelLarge,
    ),
    content: StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Cores",
            style: Theme.of(context).textTheme.labelMedium,
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
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            child: Text(cor,
                                style:
                                    Theme.of(context).textTheme.headlineSmall)),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Matéria",
            style: Theme.of(context).textTheme.labelMedium,
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
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            child: Text(
                              e.nome,
                              style: Theme.of(context).textTheme.headlineSmall,
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
