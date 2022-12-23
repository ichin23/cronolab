import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/colors.dart';

Future addMateria(
    BuildContext context, String turmaID, Function() setstate) async {
  bool loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode nomeFoc = FocusNode();
  FocusNode profFoc = FocusNode();
  FocusNode contatoFoc = FocusNode();
  TextEditingController nome = TextEditingController();
  TextEditingController prof = TextEditingController();
  TextEditingController contato = TextEditingController();

  // nome.text = materia.nome;
  // prof.text = materia.prof.toString();
  // contato.text = materia.contato.toString();
  await Get.bottomSheet(StatefulBuilder(builder: (context, setState) {
    return BottomSheet(onClosing: () {
      setState(() {});
    }, builder: (context) {
      return SingleChildScrollView(
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
                          style: Theme.of(context).textTheme.bodyMedium,
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
                              labelStyle:
                                  Theme.of(context).textTheme.headlineSmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        TextFormField(
                          enabled: true,
                          style: Theme.of(context).textTheme.bodyMedium,
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
                              icon: const Icon(Icons.border_color,
                                  color: whiteColor),
                              labelStyle:
                                  Theme.of(context).textTheme.headlineSmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        TextFormField(
                          enabled: true,
                          style: Theme.of(context).textTheme.bodyMedium,
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
                              icon: const Icon(Icons.border_color,
                                  color: whiteColor),
                              labelStyle:
                                  Theme.of(context).textTheme.headlineSmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        TextButton(
                            onPressed: () async {
                              debugPrint("OKOK");
                              String url =
                                  "https://cronolab-server.herokuapp.com";
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                debugPrint("OKOK");
                                await FirebaseFirestore.instance
                                    .collection("turmas")
                                    .doc(turmaID)
                                    .collection("materias")
                                    .add({
                                  "nome": nome.text,
                                  "professor": prof.text,
                                  "contato": contato.text
                                })
                                    // var response = await http
                                    //     .put(Uri.parse(url + "/class/materia"),
                                    //         headers: {
                                    //           "Content-Type":
                                    //               "application/json",
                                    //           "authorization": "Bearer " +
                                    //               FirebaseAuth
                                    //                   .instance.currentUser!.uid
                                    //         },
                                    //         body: jsonEncode({
                                    //           "turmaID": turmaID,
                                    //           "data": {
                                    //             "nome": nome.text,
                                    //             "professor": prof.text,
                                    //             "contato": contato.text
                                    //           }
                                    //         }))
                                    .then((value) => Get.back());

                                await setstate();
                              }
                            },
                            child: loading
                                ? const CircularProgressIndicator()
                                : const Text("Salvar"))
                      ])))));
    });
  }));
}
