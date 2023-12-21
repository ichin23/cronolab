import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/shared/colors.dart' as colors;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DeverDetails extends StatefulWidget {
  const DeverDetails(this.dever, this.tagNumber, {Key? key}) : super(key: key);
  final Dever dever;
  final int tagNumber;

  @override
  State<DeverDetails> createState() => _DeverDetailsState();
}

class _DeverDetailsState extends State<DeverDetails> {
  TextEditingController title = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController hora = TextEditingController();
  TextEditingController local = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  FocusNode titleNode = FocusNode();
  FocusNode dataNode = FocusNode();
  FocusNode horaNode = FocusNode();
  FocusNode localNode = FocusNode();

  DateTime? novaData;

  // bool edit = false;
  late Dever dever;
  bool editavel = false;
  InputDecoration fieldDecoration = InputDecoration(
      fillColor: colors.whiteColor.withOpacity(0.1),
      filled: true,
      counterText: "",
      // suffix: Icon(Icons.person),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none));

  DateFormat dateStr = DateFormat("dd/MM/yyyy");
  DateFormat horaStr = DateFormat("HH:mm");

  @override
  void initState() {
    super.initState();
    dever = widget.dever;
    title.text = dever.title;
    data.text = dateStr.format(dever.data);
    hora.text = horaStr.format(dever.data);
    local.text = dever.local ?? "";
    //editavel = TurmasLocal.to.turmaAtual!.isAdmin;
    editavel = false;
    // debugPrint(editavel);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
        title: const Text("Dever"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: ListView(children: [
              Text("Título", style: Theme.of(context).textTheme.labelMedium),
              TextField(
                  decoration: fieldDecoration,
                  maxLength: 20,
                  readOnly: !editavel,
                  style: Theme.of(context).textTheme.labelLarge,
                  controller: title,
                  focusNode: titleNode),
              const SizedBox(height: 15),
              Text("Data", style: Theme.of(context).textTheme.labelMedium),
              TextFormField(
                  decoration: fieldDecoration,
                  readOnly: true,
                  onTap: editavel
                      ? () async {
                          var newDate = await showDatePicker(
                              context: context,
                              initialDate: dever.data,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365)));

                          if (newDate != null) {
                            newDate = newDate.add(Duration(
                                hours: dever.data.hour,
                                minutes: dever.data.minute));
                            if (!newDate.isAtSameMomentAs(dever.data)) {
                              novaData = newDate;
                            }
                          }
                        }
                      : null,
                  style: Theme.of(context).textTheme.labelLarge,
                  controller: data),
              const SizedBox(height: 15),
              Text("Hora", style: Theme.of(context).textTheme.labelMedium),
              TextFormField(
                  decoration: fieldDecoration,
                  readOnly: true,
                  onTap: editavel
                      ? () async {
                          var newHora = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(dever.data),
                          );

                          if (newHora != null) {
                            var newDate = DateTime(
                                dever.data.year,
                                dever.data.month,
                                dever.data.day,
                                newHora.hour,
                                newHora.minute);
                            if (!newDate.isAtSameMomentAs(dever.data)) {
                              novaData = newDate;
                            }
                          }
                        }
                      : null,
                  style: Theme.of(context).textTheme.labelLarge,
                  controller: hora),
              const SizedBox(height: 15),
              Text("Local", style: Theme.of(context).textTheme.labelMedium),
              TextFormField(
                  decoration: fieldDecoration,
                  maxLength: 20,
                  readOnly: !editavel,
                  style: Theme.of(context).textTheme.labelLarge,
                  controller: local,
                  focusNode: localNode),
              const SizedBox(height: 15),
              Text("Matéria", style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 10),
              Container(
                  width: width - 30,
                  height: height * 0.25,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colors.whiteColor.withOpacity(0.1),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: width * 0.7 - 50,
                                child: Text("Matéria: ${dever.materiaID}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Professor: ${dever.materiaID}",
                                style: Theme.of(context).textTheme.labelMedium),
                            const SizedBox(height: 10),
                            Text("Contato: ${dever.materiaID}",
                                style: Theme.of(context).textTheme.labelMedium)
                          ],
                        ),
                      ]))
            ]),
          ),
        ),
      ),
      /*floatingActionButton: Consumer<Turmas>(
        builder: (context, turmas, _) => turmas.turmaAtual!.isAdmin
            ? FloatingActionButton(
                onPressed: () async {
                  editavel = !editavel;
                  if (editavel) {
                    novaData = null;

                    titleNode.requestFocus();
                  } else {
                    Map<String, dynamic> update = {};
                    if (dever.title != title.text) {
                      update["title"] = title.text;
                    }
                    if (dever.local != local.text) {
                      update["local"] = local.text;
                    }
                    if (novaData != null) {
                      update["data"] = novaData;
                    }
                    if (update.isNotEmpty) {
                      update["ultimaModificacao"] = Timestamp.now();
                      var cancel = BotToast.showLoading();

                      titleNode.requestFocus();
                      titleNode.unfocus();
                      await turmas.turmasFB.updateDever(
                          turmas.turmaAtual!.id, dever.id!, update);
                      var novosDeveres = await turmas.turmasFB.refreshTurma(
                          turmas.turmaAtual!.id,
                          Timestamp.fromDate(await turmas.turmasSQL
                              .readUltimaModificacao(turmas.turmaAtual!.id)));
                      for (var dever in novosDeveres) {
                        await turmas.turmasSQL
                            .createDever(dever, turmas.turmaAtual!.id);
                      }
                      await turmas.getData();
                      Navigator.pop(context);
                      cancel();
                    }
                  }
                  setState(() {});
                },
                child: Icon(editavel ? Icons.check : Icons.edit,
                    color: darkPrimary))
            : Container(),
      ),*/
    );
  }
}
