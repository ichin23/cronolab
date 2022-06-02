import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

DateFormat dateStr = DateFormat("dd/MM");
cadastra(BuildContext context, var turmas, Function() setState) async {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titulo = TextEditingController();
  TextEditingController materia = TextEditingController();
  TextEditingController pontos = TextEditingController();
  // String? senhaField;
  FocusNode tituloFoc = FocusNode();
  FocusNode materiaFoc = FocusNode();
  FocusNode pontosFoc = FocusNode();
  DateTime? dia;
  TimeOfDay? hora;

  await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return BottomSheet(
              backgroundColor: black,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              onClosing: () {
                setState(() {});
              },
              builder: (context) {
                return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                focusNode: tituloFoc,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Digite algum valor";
                                  }
                                  return null;
                                },
                                controller: titulo,
                                decoration: InputDecoration(
                                    label: const Text("Título"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                focusNode: materiaFoc,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Digite algum valor";
                                  }
                                  return null;
                                },
                                controller: materia,
                                decoration: InputDecoration(
                                    label: const Text("Matéria"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                focusNode: pontosFoc,
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Digite algum valor";
                                  }
                                  return null;
                                },
                                controller: pontos,
                                decoration: InputDecoration(
                                    label: const Text("Valor/Pontuação"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text("Data"),
                                  TextButton(
                                      onPressed: () async {
                                        dia = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            initialDate: DateTime.now(),
                                            lastDate: DateTime.now().add(
                                                const Duration(days: 365)));
                                        setState(() {});
                                      },
                                      child: Text(
                                        dia == null
                                            ? "--/--/----"
                                            : dateStr.format(dia!)
                                        // : dia!.day
                                        //         .toString() +
                                        //     "/" +
                                        //     dia!.month
                                        //         .toString() +
                                        //     "/" +
                                        //     dia!.year
                                        //         .toString()
                                        ,
                                        style: TextStyle(color: white),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Hora",
                                    style: TextStyle(color: white),
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        hora = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now());
                                        setState(() {});
                                      },
                                      child: Text(
                                        hora == null
                                            ? "--:--"
                                            : hora!.hour.toString() +
                                                ":" +
                                                hora!.minute.toString(),
                                        style: TextStyle(color: white),
                                      )),
                                ],
                              ),
                              OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              darkPrimary)),
                                  onPressed: () async {
                                    if (dia == null || hora == null) {
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("OK"))
                                                ],
                                                title: const Text(
                                                    "Faltam valores"),
                                                content: const Text(
                                                    "Insira a data/hora"),
                                              ));
                                      return;
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      // print(turmas
                                      //     .turmaAtual!
                                      //     .id);
                                      await turmas.turmaAtual!.addDever(
                                          Dever(
                                              data: DateTime(
                                                  dia!.year,
                                                  dia!.month,
                                                  dia!.day,
                                                  hora!.hour,
                                                  hora!.minute),
                                              materia: materia.text,
                                              title: titulo.text,
                                              pontos:
                                                  double.parse(pontos.text)),
                                          turmas);
                                      // FirestoreApp().getData(Dever(
                                      //     data: Timestamp
                                      //         .fromDate(DateTime(
                                      //             dia!.year,
                                      //             dia!.month,
                                      //             dia!.day,
                                      //             hora!.hour,
                                      //             hora!
                                      //                 .minute)),
                                      //     materia:[]
                                      //         materia.text,
                                      //     title: titulo.text,
                                      //     pontos: double
                                      //         .parse(pontos
                                      //             .text)));
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text(
                                    "Salvar",
                                    style: TextStyle(color: white),
                                  ))
                            ],
                          ),
                        ),
                      )),
                );
              });
        });
      });

  setState();
}
