import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/shared/colors.dart' as colors;
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DeverDetails extends StatefulWidget {
  const DeverDetails({Key? key}) : super(key: key);
  //final Dever dever;

  @override
  State<DeverDetails> createState() => _DeverDetailsState();
}

class _DeverDetailsState extends State<DeverDetails> {
  TextEditingController title = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController hora = TextEditingController();
  TextEditingController local = TextEditingController();
  // bool edit = false;
  Dever dever = Get.arguments as Dever;
  bool editavel = false;
  InputDecoration fieldDecoration = InputDecoration(
      fillColor: colors.white.withOpacity(0.1),
      filled: true,
      // suffix: Icon(Icons.person),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none));

  DateFormat dateStr = DateFormat("dd/MM/yyyy");
  DateFormat horaStr = DateFormat("hh:mm");

  @override
  void initState() {
    super.initState();
    title.text = dever.title;
    data.text = dateStr.format(dever.data);
    hora.text = horaStr.format(dever.data);
    local.text = dever.local ?? "";
    editavel = TurmasState.to.turmaAtual!.isAdmin;
    // print(editavel);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
        title: const Text("Dever"),
      ),
      backgroundColor: colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(children: [
            const Text("Título", style: label),
            TextField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: inputDever,
                controller: title),
            const SizedBox(height: 15),
            const Text("Data", style: label),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: inputDever,
                controller: data),
            const SizedBox(height: 15),
            const Text("Hora", style: label),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: inputDever,
                controller: hora),
            const SizedBox(height: 15),
            const Text("Local", style: label),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: inputDever,
                controller: local),
            const SizedBox(height: 15),
            const Text("Matéria", style: label),
            const SizedBox(height: 10),
            Container(
                width: width - 30,
                height: height * 0.25,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors.white.withOpacity(0.1),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: width * 0.7 - 50,
                          child: Text("Nome: ${dever.materia!.prof}",
                              style: label),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Matéria: ${dever.materia!.nome}", style: label),
                      const SizedBox(height: 10),
                      Text("Contato: ${dever.materia!.contato}", style: label)
                    ],
                  ),
                ]))
          ]),
        ),
      ),
    );
  }
}
