import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../materia/materia.dart';

DateFormat dateStr = DateFormat("dd/MM/yy");

cadastra(BuildContext context, TurmasServer turmas, Function() setState) async {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titulo = TextEditingController();
  TextEditingController materia = TextEditingController();
  TextEditingController pontos = TextEditingController();
  TextEditingController local = TextEditingController();
  bool loading = false;

  // String? senhaField;
  Materia? materiaSelect;
  FocusNode tituloFoc = FocusNode();
  FocusNode materiaFoc = FocusNode();
  FocusNode pontosFoc = FocusNode();
  FocusNode localFoc = FocusNode();
  DateTime? dia;
  TimeOfDay? hora;

  DateFormat dataStr = DateFormat("dd/MM");
  DateFormat horaStr = DateFormat("HH:mm");

  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
            return BottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                onClosing: () {
                  setState();
                },
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).viewInsets.bottom + 150,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    enabled: true,
                                    maxLength: 20,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.next,
                                    focusNode: tituloFoc,
                                    onFieldSubmitted: (value) {
                                      materiaFoc.requestFocus();
                                    },
                                    controller: titulo,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        label: const Text("Título"),
                                        icon: const Icon(Icons.border_color,
                                            color: whiteColor),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  const SizedBox(height: 10),

                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    focusNode: materiaFoc,
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          materiaSelect == null) {
                                        return "Selecione alguma matéria";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setstate(() {});
                                    },
                                    controller: materia,
                                    decoration: InputDecoration(
                                        label: const Text("Matéria"),
                                        icon: const Icon(Icons.menu_book,
                                            color: whiteColor),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  const SizedBox(height: 5),
                                  // ListTile(
                                  //     title:
                                  //         Text(turmas.turmaAtual!.materias[0])),
                                  Container(
                                    margin: const EdgeInsets.only(left: 40),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: whiteColor.withOpacity(0.1),
                                        ),
                                        child: ListView(
                                          children: const [
                                            /* ...(turmas.turmaAtual!.materia)
                                                .where((Materia element) =>
                                                    element.nome
                                                        .toLowerCase()
                                                        .startsWith(materia.text
                                                            .toLowerCase()))
                                                .map((e) => ListTile(
                                                    title: Text(e.nome,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium),
                                                    onTap: () {
                                                      materiaSelect = e;
                                                      materia.text = e.nome;
                                                      setstate(() {});
                                                    }))
                                                .toList(),
                                            turmas.turmaAtual!.materia
                                                    .where((element) => element
                                                        .nome
                                                        .toLowerCase()
                                                        .startsWith(materia.text
                                                            .toLowerCase()))
                                                    .isEmpty
                                                ? //TextButton(
                                                // onPressed: () async {
                                                //   await addMateria(
                                                //       context, turmas.turmaAtual!.id,
                                                //       () async {
                                                //     await TurmasState.to.getTurmas();
                                                //     await turmas.getTurmas(
                                                //         updateTurma: false);
                                                //     Get.back();
                                                //     setState(() {});
                                                //   }).then((value) async {
                                                //     debugPrint("acabou");
                                                //     await turmas.changeTurmaAtualWithID(
                                                //         turmas.turmaAtual!.id);

                                                //     setState(() {});
                                                //   });
                                                //   debugPrint("realmente acabou");
                                                // },
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0),
                                                        child: Text(
                                                          "${materia.text} não encontrado",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelMedium,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container()*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    maxLength: 10,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    focusNode: pontosFoc,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Digite algum valor";
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      localFoc.requestFocus();
                                    },
                                    controller: pontos,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      label: const Text("Valor/Pontuação"),
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      icon: const Icon(Icons.check_box,
                                          color: whiteColor),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    maxLength: 20,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    focusNode: localFoc,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      localFoc.unfocus();
                                    },
                                    controller: local,
                                    decoration: InputDecoration(
                                      label: const Text("Local"),
                                      counterText: "",
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                      hintText: "Ex: Moodle, Classroom",
                                      hintStyle: const TextStyle(
                                          fontSize: 16, color: whiteColor),
                                      icon: const Icon(Icons.public,
                                          color: whiteColor),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  // DropdownButton<String>(
                                  //     value: "Selecione",
                                  //     items: [
                                  //       DropdownMenuItem<String>(
                                  //           child: Text("Selecione")),
                                  //       ...turmas.turmaAtual!.materias
                                  //           .map((e) => DropdownMenuItem<String>(
                                  //               child: Text(e)))
                                  //           .toList()
                                  //     ],
                                  //     onChanged: (value) {}),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          color: whiteColor),
                                      const SizedBox(width: 20),
                                      const Text(
                                        "Data",
                                        style: TextStyle(color: whiteColor),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            localFoc.unfocus();
                                            tituloFoc.unfocus();
                                            materiaFoc.unfocus();
                                            dia = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                initialDate: DateTime.now(),
                                                cancelText: "Cancelar",
                                                confirmText: "Selecionar",
                                                helpText: "Selecione uma data",
                                                lastDate: DateTime.now().add(
                                                    const Duration(days: 365)));
                                            setstate(() {});
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: whiteColor),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Hora",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            debugPrint(hora.toString());
                                            TimeOfDay? newHora =
                                                await showTimePicker(
                                                    context: context,
                                                    cancelText: "Cancelar",
                                                    confirmText: "Selecionar",
                                                    helpText:
                                                        "Selecionar uma hora",
                                                    minuteLabelText: "Minutos",
                                                    hourLabelText: "Hora",
                                                    builder:
                                                        (context, child) =>
                                                            Theme(
                                                                data: ThemeData(
                                                                  primaryColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                  colorScheme: ColorScheme.dark(
                                                                          primary: Theme.of(context)
                                                                              .primaryColor)
                                                                      .copyWith(
                                                                          background: Theme.of(context)
                                                                              .colorScheme
                                                                              .background),
                                                                ),
                                                                child: child!),
                                                    initialTime: hora != null
                                                        ? hora!
                                                        : TimeOfDay.now());
                                            debugPrint(newHora.toString());
                                            if (newHora != null) {
                                              hora = newHora;
                                            }
                                            setstate(() {});
                                          },
                                          child: Text(
                                            hora == null
                                                ? "--:--"
                                                : hora!.format(context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          )),
                                    ],
                                  ),
                                  OutlinedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  darkPrimary)),
                                      onPressed: loading
                                          ? null
                                          : () async {
                                              if (dia == null || hora == null) {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "OK"))
                                                          ],
                                                          title: const Text(
                                                              "Faltam valores"),
                                                          content: const Text(
                                                              "Insira a data/hora"),
                                                        ));
                                                return;
                                              }
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setstate(() {
                                                  loading = true;
                                                });
                                                // debugPrint(turmas
                                                //     .turmaAtual!
                                                //     .id);
                                                // await turmas.turmaAtual!.addDever(
                                                /* await turmas.turmasFB
                                                    .createDever(
                                                        Dever(
                                                            //id: FirebaseFirestore.instance.collection("dever").doc().id,
                                                            data: DateTime(
                                                                dia!.year,
                                                                dia!.month,
                                                                dia!.day,
                                                                hora!.hour,
                                                                hora!.minute),
                                                            materiaID:
                                                                materiaSelect!
                                                                    .id,
                                                            title: titulo.text,
                                                            ultimaModificacao:
                                                                DateTime.now(),
                                                            pontos:
                                                                double.parse(
                                                                    pontos
                                                                        .text),
                                                            local: local.text),
                                                        turmas.turmaAtual!.id);
                                                var lastUpdate = (await turmas
                                                    .turmasSQL
                                                    .getUpdate());
                                                var newDeveres = await turmas
                                                    .turmasFB
                                                    .refreshTurma(
                                                        turmas.turmaAtual!.id,
                                                        Timestamp.fromDate(
                                                            lastUpdate));

                                                for (var dever in newDeveres) {
                                                  await turmas.turmasSQL
                                                      .createDever(
                                                          dever,
                                                          turmas
                                                              .turmaAtual!.id);
                                                }

                                                await turmas.getData();
*/
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
                                                setstate(() {
                                                  loading = false;
                                                });
                                                // Provider.of<IndexController>(
                                                //         context)
                                                //     .loadData(
                                                //         Provider.of<TurmasState>(
                                                //             context,
                                                //             listen: false),
                                                //         turmas);
                                                Navigator.of(context).pop();
                                              }
                                            },
                                      child: loading
                                          ? Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                              ),
                                            )
                                          : Text(
                                              "Salvar",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            )),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  );
                });
          }));

  setState();
}
