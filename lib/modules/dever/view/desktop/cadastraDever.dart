import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/dever/view/mobile/cadastraDever.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/controllers/turmasRepository.dart';
import 'package:cronolab/shared/models/settings.dart' as sett;
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'package:intl/intl.dart';

cadastraDeverDesktop(BuildContext context, DateTime? data) async {
  DateFormat date = DateFormat("dd/MM");
  TimeOfDay? hora;
  TurmasServer turmas = GetIt.I.get<TurmasServer>();
  var _form = GlobalKey<FormState>();
  var titulo = TextEditingController();
  var local = TextEditingController();
  var pontos = TextEditingController();
  var descricao = TextEditingController();

  print(turmas.getMateriasFromTurma(turmas.turmaAtual.value!));

  Materia? materiaSelect;
  await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.23),
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
                      Text(
                          "Cadastrar Matéria para o dia: ${data == null ? '' : date.format(data!)}",
                          style: fonts.labelDark),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                      maxLength: 50,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          )),
                                      borderRadius: BorderRadius.circular(10),
                                      dropdownColor: backgroundDark,
                                      items: turmas
                                          .getMateriasFromTurma(
                                              turmas.turmaAtual.value!)
                                          .map((e) => DropdownMenuItem(
                                                child: Text(
                                                  e.nome +
                                                      (e.prof != null
                                                          ? " - " +
                                                              e.prof.toString()
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
                                      maxLength: 8,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ))),
                                  const SizedBox(height: 15),
                                  /*TextFormField(
                                      controller: local,
                                      maxLength: 20,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ))),
                                  const SizedBox(height: 15),*/
                                  Row(children: [
                                    const Icon(Icons.calendar_month,
                                        color: whiteColor),
                                    const SizedBox(width: 20),
                                    const Text(
                                      "Data: ",
                                      style: fonts.labelDark,
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          data = await showDatePicker(
                                              builder: (context, child) =>
                                                  Theme(
                                                    data: ThemeData.dark(
                                                            useMaterial3: true)
                                                        .copyWith(
                                                            primaryColor:
                                                                primaryDark),
                                                    child: child!,
                                                  ),
                                              context: context,
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 365)),
                                              initialDate: DateTime.now());
                                          setstate(() {});
                                        },
                                        child: Text(
                                          data != null
                                              ? dateStr.format(data!)
                                              : "Selecione",
                                          style: TextStyle(
                                              color: hora == null
                                                  ? primaryDark
                                                  : whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                        ))
                                  ]),
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
                                              builder: (context, child) =>
                                                  Theme(
                                                    data: ThemeData.dark(
                                                            useMaterial3: true)
                                                        .copyWith(
                                                            primaryColor:
                                                                primaryDark),
                                                    child: child!,
                                                  ),
                                              context: context,
                                              initialTime: TimeOfDay.now());
                                          setstate(() {});
                                        },
                                        child: Text(
                                          hora?.format(context) ?? "Selecione",
                                          style: TextStyle(
                                              color: hora == null
                                                  ? primaryDark
                                                  : whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                        ))
                                  ]),
                                ]),
                          ),
                          Container(
                            width: 2,
                            height: MediaQuery.of(context).size.height * 0.3,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            color: Colors.white30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Notas: ", style: fonts.labelDark),
                                TextFormField(
                                    maxLines: 12,
                                    controller: descricao,
                                    style: fonts.labelDark,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ))),
                              ],
                            ),
                          )
                        ],
                      ),
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
                            var dever = Dever(
                                data: DateTime(data!.year, data!.month,
                                    data!.day, hora!.hour, hora!.minute),
                                descricao: descricao.text,
                                materiaID: materiaSelect!.id,
                                title: titulo.text,
                                pontos: double.parse(pontos.text));
                            await turmas.cadastraDever(dever);
                            Navigator.pop(context);
                            turmas.getData().then((value) => GetIt.I
                                .get<DeveresController>()
                                .buildCalendar(DateTime.now(), context));
                            /*await FirebaseFirestore.instance
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
                                .then((value) => Navigator.pop(context));*/
                          },
                          child: const Text("Cadastra"))
                    ],
                  ),
                ),
              ),
            );
          }));
}
