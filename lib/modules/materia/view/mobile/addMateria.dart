import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../shared/colors.dart';
import '../../../../shared/fonts.dart' as fonts;

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
    return BottomSheet(
        backgroundColor: black,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
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
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            TextFormField(
                              enabled: true,
                              style: fonts.white,
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
                                      color: white),
                                  labelStyle: fonts.input,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                            ),
                            TextFormField(
                              enabled: true,
                              style: fonts.white,
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
                                      color: white),
                                  labelStyle: fonts.input,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                            ),
                            TextFormField(
                              enabled: true,
                              style: fonts.white,
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
                                      color: white),
                                  labelStyle: fonts.input,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                            ),
                            TextButton(
                                onPressed: () async {
                                  print("OKOK");
                                  String url =
                                      "https://cronolab-server.herokuapp.com";
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    print("OKOK");
                                    var response = await http
                                        .put(Uri.parse(url + "/class/materia"),
                                            headers: {
                                              "Content-Type":
                                                  "application/json",
                                              "authorization": "Bearer " +
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                            },
                                            body: jsonEncode({
                                              "turmaID": turmaID,
                                              "data": {
                                                "nome": nome.text,
                                                "professor": prof.text,
                                                "contato": contato.text
                                              }
                                            }))
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
