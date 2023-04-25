import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/shared/colors.dart' as colors;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DeverDetails extends StatefulWidget {
  const DeverDetails(this.dever, {Key? key}) : super(key: key);
  final Dever dever;

  @override
  State<DeverDetails> createState() => _DeverDetailsState();
}

class _DeverDetailsState extends State<DeverDetails> {
  TextEditingController title = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController hora = TextEditingController();
  TextEditingController local = TextEditingController();
  // bool edit = false;
  late Dever dever;
  bool editavel = false;
  InputDecoration fieldDecoration = InputDecoration(
      fillColor: colors.whiteColor.withOpacity(0.1),
      filled: true,
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
          child: ListView(children: [
            Text("Título", style: Theme.of(context).textTheme.labelMedium),
            TextField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: Theme.of(context).textTheme.labelLarge,
                controller: title),
            const SizedBox(height: 15),
            Text("Data", style: Theme.of(context).textTheme.labelMedium),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: Theme.of(context).textTheme.labelLarge,
                controller: data),
            const SizedBox(height: 15),
            Text("Hora", style: Theme.of(context).textTheme.labelMedium),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: Theme.of(context).textTheme.labelLarge,
                controller: hora),
            const SizedBox(height: 15),
            Text("Local", style: Theme.of(context).textTheme.labelMedium),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: Theme.of(context).textTheme.labelLarge,
                controller: local),
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Flexible(
                        child: SizedBox(
                          width: width * 0.7 - 50,
                          child: Text("Matéria: ${dever.materia!.nome}",
                              style: Theme.of(context).textTheme.labelMedium),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Professor: ${dever.materia!.prof}",
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 10),
                      Text("Contato: ${dever.materia!.contato}",
                          style: Theme.of(context).textTheme.labelMedium)
                    ],
                  ),
                ]))
          ]),
        ),
      ),
    );
  }
}
