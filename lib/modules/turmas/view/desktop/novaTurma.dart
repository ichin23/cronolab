import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

novaTurma(BuildContext context, [bool criarTurma = false, String? turmaId]) {
  TextEditingController code = TextEditingController();
  TextEditingController nome = TextEditingController();

  code.text = turmaId ?? "";
  TurmasServer turmas = GetIt.I.get<TurmasServer>();
  bool loading = false;
  showDialog(
      context: context,
      builder: (context) => turmas.turmas.value.length < 3
          ? StatefulBuilder(builder: (context, setstate) {
              return AlertDialog(
                content: Container(
                  constraints: const BoxConstraints(minHeight: 100),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Digite o código da turma",
                          style: labelDark,
                        ),
                        const SizedBox(height: 8),
                        TextField(style: labelDark, controller: code),
                        criarTurma
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Nome da turma:",
                                    style: labelDark,
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(style: labelDark, controller: nome),
                                ],
                              )
                            : Container(),
                        const SizedBox(height: 8),
                        TextButton(
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text("Adicionar"),
                          onPressed: loading
                              ? null
                              : () async {
                                  try {
                                    loading = true;
                                    setstate(() {});
                                    if (criarTurma) {
                                      await turmas.criarTurma(
                                          code.text, nome.text);
                                    } else {
                                      //TODO: Criar turma
                                      turmas.enterTurma(code.text);
                                    }
                                    loading = false;
                                    setstate(() {});
                                    Navigator.pop(context);
                                    turmas.getData();
                                  } catch (e) {
                                    rethrow;
                                  }
                                },
                        )
                      ]),
                ),
              );
            })
          : AlertDialog(
              content: Container(
                child: const Text(
                  "Você já atingiu o limite de turmas!",
                  style: labelDark,
                ),
              ),
            ));
}
