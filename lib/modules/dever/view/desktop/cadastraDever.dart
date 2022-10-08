import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

cadastraDeverDesktop(BuildContext context, DateTime data) async {
  DateFormat date = DateFormat("dd/MM");
  TimeOfDay? hora;
  var _form = GlobalKey<FormState>();
  var titulo = TextEditingController();
  var local = TextEditingController();
  var pontos = TextEditingController();

  Materia? materiaSelect;
  await Get.dialog(
      //context: context,

      StatefulBuilder(builder: (context, setstate) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.3),
      backgroundColor: black,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: black, borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Cadastrar Matéria para o dia: ${date.format(data)}",
                  style: fonts.label),
              const SizedBox(height: 15),
              TextFormField(
                  controller: titulo,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Digite um valor";
                    }
                    return null;
                  },
                  style: fonts.label,
                  decoration: InputDecoration(
                      label: const Text("Título"),
                      icon: const Icon(Icons.border_color, color: white),
                      labelStyle: fonts.input,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
              const SizedBox(height: 15),
              /* TextFormField(
                    decoration: InputDecoration(
                        label: const Text("Matéria"),
                        icon: const Icon(Icons.border_color, color: white),
                        labelStyle: fonts.input,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))), */
              DropdownButtonFormField<Materia>(
                  value: materiaSelect,
                  decoration: InputDecoration(
                      label: const Text("Matéria"),
                      icon: const Icon(Icons.border_color, color: white),
                      labelStyle: fonts.input,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: black,
                  items: TurmasState.to.turmaAtual!.materias
                      .map((e) => DropdownMenuItem(
                            child: Text(
                              e.nome +
                                  (e.prof != null
                                      ? " - " + e.prof.toString()
                                      : ""),
                              style: fonts.label,
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
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Digite um valor";
                    }
                    return null;
                  },
                  style: fonts.label,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"^\d+(\.|,?)(\d{1,2})?"))
                  ],
                  decoration: InputDecoration(
                      label: const Text("Valor/Pontuação"),
                      icon: const Icon(Icons.border_color, color: white),
                      labelStyle: fonts.input,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
              const SizedBox(height: 15),
              TextFormField(
                  controller: local,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Digite um valor";
                    }
                    return null;
                  },
                  style: fonts.label,
                  inputFormatters: const [],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: const Text("Local"),
                      icon: const Icon(Icons.border_color, color: white),
                      labelStyle: fonts.input,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
              const SizedBox(height: 15),
              Row(children: [
                const Icon(Icons.timer, color: white),
                const SizedBox(width: 20),
                const Text(
                  "Hora: ",
                  style: fonts.label,
                ),
                TextButton(
                    onPressed: () async {
                      hora = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      setstate(() {});
                    },
                    child: Text(
                      hora?.format(context) ?? "Selecione",
                      style: TextStyle(
                          color: hora == null ? primary2 : white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ))
              ]),
              const SizedBox(height: 15),
              TextButton(
                  onPressed: () async {
                    print("Começa");
                    if (!_form.currentState!.validate()) {
                      return;
                    }
                    if (hora == null) {
                      print("Hora não inserida");
                      return;
                    }
                    if (materiaSelect == null) {
                      print("Matéria não selecionada");
                      return;
                    }
                    print("Cadastrando");
                    await TurmasState.to.turmaAtual!
                        .addDever(Dever(
                            data: DateTime(data.year, data.month, data.day,
                                hora!.hour, hora!.minute),
                            materiaID: materiaSelect!.id,
                            title: titulo.text,
                            pontos: double.parse(pontos.text),
                            local: local.text))
                        .then((value) {
                      print("Cadastrado");
                    });
                  },
                  child: const Text("Cadastra"))
            ],
          ),
        ),
      ),
    );
  }));
}
