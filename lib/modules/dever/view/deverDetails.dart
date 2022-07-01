import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/shared/colors.dart' as colors;
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeverDetails extends StatefulWidget {
  DeverDetails(this.dever, {Key? key}) : super(key: key);
  Dever dever;

  @override
  State<DeverDetails> createState() => _DeverDetailsState();
}

class _DeverDetailsState extends State<DeverDetails> {
  TextEditingController title = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController hora = TextEditingController();
  // bool edit = false;
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
    title.text = widget.dever.title;
    data.text = dateStr.format(widget.dever.data);
    hora.text = horaStr.format(widget.dever.data);
    editavel =
        Provider.of<TurmasProvider>(context, listen: false).turmaAtual!.isAdmin;
    // print(editavel);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: colors.primary,
          title: Text("Dever"),
          centerTitle: true),
      backgroundColor: colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(children: [
            Text("Título", style: label),
            TextField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: inputDever,
                controller: title),
            SizedBox(height: 15),
            Text("Data", style: label),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: inputDever,
                controller: data),
            SizedBox(height: 15),
            Text("Hora", style: label),
            TextFormField(
                decoration: fieldDecoration,
                readOnly: !editavel,
                style: inputDever,
                controller: hora),
            SizedBox(height: 15),
            Text("Matéria", style: label),
            SizedBox(height: 10),
            Container(
                width: width - 30,
                height: height * 0.25,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors.white.withOpacity(0.1),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              width: width * 0.7 - 50,
                              child: Text("Nome: ${widget.dever.materia!.prof}",
                                  style: label),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Matéria: ${widget.dever.materia!.nome}",
                              style: label),
                          SizedBox(height: 10),
                          Text("Contato: ${widget.dever.materia!.contato}",
                              style: label)
                        ],
                      ),
                      Container(
                          height: height * 0.2,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: colors.black,
                          ),
                          child:
                              Icon(Icons.person, color: colors.white, size: 50))
                    ]))
          ]),
        ),
      ),
    );
  }
}
