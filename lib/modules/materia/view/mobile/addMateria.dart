import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  await showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
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
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      enabled: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      keyboardType: TextInputType.name,
                                      textCapitalization:
                                          TextCapitalization.sentences,
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
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      enabled: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      keyboardType: TextInputType.name,
                                      textCapitalization:
                                          TextCapitalization.sentences,
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
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      enabled: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      keyboardType: TextInputType.name,
                                      textCapitalization:
                                          TextCapitalization.sentences,
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
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            debugPrint("OKOK");
                                            if (kIsWeb) {
                                              await context
                                                  .read<TurmasStateDesktop>()
                                                  .createMateria(
                                                      Materia(
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "turmas")
                                                              .doc()
                                                              .id,
                                                          nome.text,
                                                          prof.text,
                                                          contato.text),
                                                      turmaID);
                                            } else {
                                              await context
                                                  .read<Turmas>()
                                                  .turmasSQL
                                                  .createMateria(
                                                      Materia(
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "turmas")
                                                              .doc()
                                                              .id,
                                                          nome.text,
                                                          prof.text,
                                                          contato.text),
                                                      turmaID);
                                            }
                                            Navigator.pop(context);

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
