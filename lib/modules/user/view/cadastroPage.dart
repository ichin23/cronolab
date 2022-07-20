import 'package:cronolab/modules/user/controller/cadastroController.dart';
import 'package:cronolab/shared/colors.dart';

import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController nomeCont = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool hidePassword = true;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).padding.top +
        200;
    return Scaffold(
        backgroundColor: black,
        body: SafeArea(
            child: Form(
                key: _form,
                child: SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(40, 100, 40, 20),
                  height: height - padding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "CRONOLAB",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Hero(
                            tag: "emailField",
                            child: Material(
                              type: MaterialType.transparency,
                              child: TextFormField(
                                controller: emailCont,
                                style:
                                    const TextStyle(fontSize: 16, color: white),
                                decoration: InputDecoration(
                                    label: const Text("Email"),
                                    labelStyle: const TextStyle(color: white),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            const BorderSide(color: white))),
                              ),
                            ),
                          ),
                          const SizedBox(height: 45),
                          TextFormField(
                            controller: nomeCont,
                            style: const TextStyle(fontSize: 16, color: white),
                            decoration: InputDecoration(
                                label: const Text("Nome"),
                                labelStyle: const TextStyle(color: white),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: white))),
                          ),
                          const SizedBox(height: 45),
                          Hero(
                            tag: "senhaField",
                            child: Material(
                              type: MaterialType.transparency,
                              child: TextFormField(
                                controller: passwordCont,
                                style:
                                    const TextStyle(fontSize: 16, color: white),
                                decoration: InputDecoration(
                                    label: const Text("Senha"),
                                    labelStyle: const TextStyle(color: white),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            const BorderSide(color: white))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Hero(
                            tag: "button",
                            child: Material(
                              type: MaterialType.transparency,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: Size(width - 50, 55),
                                    backgroundColor: primary2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: black)
                                    : const Text("Cadastrar",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800)),
                                onPressed: () {
                                  if (_form.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    CadastroController().siginEmail(
                                        emailCont.text,
                                        passwordCont.text,
                                        nomeCont.text,
                                        context);
                                    Navigator.pushReplacementNamed(
                                        context, "/");
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Hero(
                            tag: "conta",
                            child: Material(
                              type: MaterialType.transparency,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Já possui conta?",
                                    style:
                                        TextStyle(color: white, fontSize: 16),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Login",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: primary2,
                                              fontSize: 16)))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )))));
  }
}
