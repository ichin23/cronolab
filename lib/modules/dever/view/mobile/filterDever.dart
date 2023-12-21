import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';

import 'package:flutter/material.dart';

Future<List> filterDever(BuildContext context, {List? oldList}) async {
  final _cores = ["Vermelha", "Amarela", "Verde"];
  List<dynamic> list = oldList ?? List.generate(2, (index) => null);
  Materia? materiaSelect;
  debugPrint(list.toString());
  int? corSelect;

  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall)),
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
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*   ...Provider.of<Turmas>(context)
                            .turmaAtual!
                            .materia
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ))
                            .toList(),*/
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 16)),
                          onPressed: () {
                            list = [null, null];
                            Navigator.pop(context);
                          },
                          child: const Text("Limpar")),
                      const SizedBox(width: 20),
                      TextButton(
                          style: const ButtonStyle(
                              //textStyle: MaterialStatePropertyAll(buttonTextDark),
                              backgroundColor:
                                  MaterialStatePropertyAll(primaryDark)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: buttonTextDark,
                          )),
                    ],
                  )
                ],
              );
            }),
          ));
  return list;
}
