import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../shared/colors.dart';
import '../../../shared/fonts.dart' as fonts;
import '../../turmas/turma.dart';
import '../../turmas/turmasProviderServer.dart';
import '../materia.dart';

String url = "https://cronolab-server.herokuapp.com";

editaMateria(BuildContext context, Materia materia, Turma turma,
    TurmasProvider turmas, Function() setState) async {
  bool loading = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode nomeFoc = FocusNode();
  FocusNode profFoc = FocusNode();
  FocusNode contatoFoc = FocusNode();
  TextEditingController nome = TextEditingController();
  TextEditingController prof = TextEditingController();
  TextEditingController contato = TextEditingController();

  nome.text = materia.nome;
  prof.text = materia.prof.toString();
  contato.text = materia.contato.toString();
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        enabled: true,
                                        style: fonts.white,
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
                                            icon: Icon(Icons.border_color,
                                                color: white),
                                            labelStyle: GoogleFonts.inter(
                                                fontSize: 16, color: white),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                      ),
                                      TextFormField(
                                        enabled: true,
                                        style: fonts.white,
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
                                            icon: Icon(Icons.border_color,
                                                color: white),
                                            labelStyle: GoogleFonts.inter(
                                                fontSize: 16, color: white),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                      ),
                                      TextFormField(
                                        enabled: true,
                                        style: fonts.white,
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
                                        controller: nome,
                                        decoration: InputDecoration(
                                            label: const Text("Contato"),
                                            icon: Icon(Icons.border_color,
                                                color: white),
                                            labelStyle: GoogleFonts.inter(
                                                fontSize: 16, color: white),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                      ),
                                      TextButton(
                                          onPressed: loading
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  await http.put(
                                                      Uri.parse(url +
                                                          "/class/edit/materia"),
                                                      headers: {
                                                        "authorization":
                                                            "Bearer " +
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                        "Content-Type":
                                                            "application/json"
                                                      },
                                                      body: jsonEncode({
                                                        "turmaID": turma.id,
                                                        "materiaID": materia.id,
                                                        "data": {
                                                          "professor":
                                                              prof.text,
                                                          "nome": nome.text,
                                                          "contato":
                                                              contato.text,
                                                        }
                                                      }));
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  Navigator.pop(context);
                                                  turmas.getTurmas();
                                                },
                                          child: loading
                                              ? CircularProgressIndicator()
                                              : Text("Salvar"))
                                    ])))));
              });
        });
      });
}
