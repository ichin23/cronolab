import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/shared/fonts.dart';

import 'package:flutter/material.dart';

import '../../../../shared/colors.dart';

import '../../materia.dart';

String url = "https://cronolab-server.herokuapp.com";

class EditarMateria extends StatefulWidget {
  EditarMateria(this.materia, this.turmaId, {super.key});
  Materia materia;
  String turmaId;
  @override
  State<EditarMateria> createState() => _EditarMateriaState();
}

class _EditarMateriaState extends State<EditarMateria> {
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode nomeFoc = FocusNode();
  FocusNode profFoc = FocusNode();
  FocusNode contatoFoc = FocusNode();
  TextEditingController nome = TextEditingController();
  TextEditingController prof = TextEditingController();
  TextEditingController contato = TextEditingController();

  @override
  void initState() {
    super.initState();
    nome.text = widget.materia.nome;
    prof.text = widget.materia.prof.toString();
    contato.text = widget.materia.contato.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                      key: _formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                          enabled: true,
                          style: inputDeverDark,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          focusNode: nomeFoc,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Digite algum valor";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // materiaFoc.requestFocus();
                          },
                          controller: nome,
                          decoration: InputDecoration(
                              label: const Text("Título"),
                              icon: const Icon(Icons.border_color,
                                  color: whiteColor),
                              labelStyle: inputDeverDark,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          enabled: true,
                          style: inputDeverDark,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          focusNode: profFoc,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Digite algum valor";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // materiaFoc.requestFocus();
                          },
                          controller: prof,
                          decoration: InputDecoration(
                              label: const Text("Professor"),
                              icon: const Icon(Icons.person, color: whiteColor),
                              labelStyle: inputDeverDark,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          enabled: true,
                          style: inputDeverDark,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          focusNode: contatoFoc,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Digite algum valor";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // materiaFoc.requestFocus();
                          },
                          controller: contato,
                          decoration: InputDecoration(
                              label: const Text("Contato"),
                              icon: const Icon(Icons.contact_page,
                                  color: whiteColor),
                              labelStyle: inputDeverDark,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        TextButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("turmas")
                                        .doc(widget.turmaId)
                                        .collection("materias")
                                        .doc(widget.materia.id)
                                        .update({
                                      "professor": prof.text,
                                      "nome": nome.text,
                                      "contato": contato.text,
                                    });

                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pop(
                                        context,
                                        Materia(widget.materia.id, nome.text,
                                            prof.text, contato.text));
                                    // turmas.getTurmas(
                                    //     Provider.of<TurmasLocal>(
                                    //         context,
                                    //         listen: false));
                                  },
                            child: loading
                                ? const CircularProgressIndicator()
                                : const Text("Salvar"))
                      ]))))),
    );
  }
}
