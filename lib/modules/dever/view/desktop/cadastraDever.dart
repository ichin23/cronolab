import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/shared/models/settings.dart' as sett;
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

cadastraDeverDesktop(BuildContext context, DateTime data) async {
  DateFormat date = DateFormat("dd/MM");
  TimeOfDay? hora;
  var _form = GlobalKey<FormState>();
  var titulo = TextEditingController();
  var local = TextEditingController();
  var pontos = TextEditingController();

  Materia? materiaSelect;
  await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3),
              backgroundColor: backgroundDark,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: backgroundDark,
                    borderRadius: BorderRadius.circular(20)),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Cadastrar Matéria para o dia: ${date.format(data)}",
                          style: fonts.labelDark),
                      const SizedBox(height: 15),
                      TextFormField(
                          maxLength: context
                              .read<sett.Settings>()
                              .settings["input"]["dever"]["titulo"],
                          controller: titulo,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Digite um valor";
                            }
                            return null;
                          },
                          style: fonts.labelDark,
                          decoration: InputDecoration(
                              counterText: "",
                              label: const Text("Título"),
                              icon: const Icon(Icons.border_color,
                                  color: whiteColor),
                              labelStyle: fonts.inputDark,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<Materia>(
                          value: materiaSelect,
                          decoration: InputDecoration(
                              label: const Text("Matéria"),
                              icon: const Icon(Icons.border_color,
                                  color: whiteColor),
                              labelStyle: fonts.inputDark,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: backgroundDark,
                          items: Provider.of<TurmasStateDesktop>(context)
                              .turmaAtual!
                              .materia
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e.nome +
                                          (e.prof != null
                                              ? " - " + e.prof.toString()
                                              : ""),
                                      style: fonts.labelDark,
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (e) {
                            materiaSelect = e;
                          }),
                      const SizedBox(height: 15),
                      TextFormField(
                          controller: pontos,
                          maxLength: context
                              .read<sett.Settings>()
                              .settings["input"]["dever"]["valor"],
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Digite um valor";
                            }
                            return null;
                          },
                          style: fonts.labelDark,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"^\d+(\.|,?)(\d{1,2})?"))
                          ],
                          decoration: InputDecoration(
                              counterText: "",
                              label: const Text("Valor/Pontuação"),
                              icon: const Icon(Icons.border_color,
                                  color: whiteColor),
                              labelStyle: fonts.inputDark,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                      const SizedBox(height: 15),
                      TextFormField(
                          controller: local,
                          maxLength: context
                              .read<sett.Settings>()
                              .settings["input"]["dever"]["local"],
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Digite um valor";
                            }
                            return null;
                          },
                          style: fonts.labelDark,
                          inputFormatters: const [],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              label: const Text("Local"),
                              icon: const Icon(Icons.border_color,
                                  color: whiteColor),
                              labelStyle: fonts.inputDark,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                      const SizedBox(height: 15),
                      Row(children: [
                        const Icon(Icons.timer, color: whiteColor),
                        const SizedBox(width: 20),
                        const Text(
                          "Hora: ",
                          style: fonts.labelDark,
                        ),
                        TextButton(
                            onPressed: () async {
                              hora = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              setstate(() {});
                            },
                            child: Text(
                              hora?.format(context) ?? "Selecione",
                              style: TextStyle(
                                  color:
                                      hora == null ? primaryDark : whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ))
                      ]),
                      const SizedBox(height: 15),
                      TextButton(
                          onPressed: () async {
                            debugPrint("Começa");
                            if (!_form.currentState!.validate()) {
                              return;
                            }
                            if (hora == null) {
                              debugPrint("Hora não inserida");
                              return;
                            }
                            if (materiaSelect == null) {
                              debugPrint("Matéria não selecionada");
                              return;
                            }
                            debugPrint("Cadastrando");
                            var deverJson = Dever(
                                    data: DateTime(data.year, data.month,
                                        data.day, hora!.hour, hora!.minute),
                                    materiaID: materiaSelect!.id,
                                    title: titulo.text,
                                    pontos: double.parse(pontos.text),
                                    local: local.text)
                                .toJson();
                            deverJson["ultimaModificacao"] = Timestamp.now();
                            deverJson["data"] =
                                (deverJson["data"] as Timestamp).toDate();
                            await FirebaseFirestore.instance
                                .collection("turmas")
                                .doc(context
                                    .read<TurmasStateDesktop>()
                                    .turmaAtual!
                                    .id)
                                .collection("deveres")
                                .add(deverJson)
                                .then((value) {
                              debugPrint("Cadastrado");
                            });
                            context
                                .read<TurmasStateDesktop>()
                                .turmaAtual!
                                .getAtividades()
                                .then((value) => context
                                    .read<DeveresController>()
                                    .buildCalendar(DateTime.now(), context))
                                .then((value) => Navigator.pop(context));
                          },
                          child: const Text("Cadastra"))
                    ],
                  ),
                ),
              ),
            );
          }));
}
