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
        body: SafeArea(
            child: Form(
                key: _form,
                child: SizedBox(
                  width: width,
                  height: height - MediaQuery.of(context).padding.bottom,
                  child: Center(
                    child: SingleChildScrollView(
                        child: SizedBox(
                      width: width * 0.8,
                      height: MediaQuery.of(context).viewInsets.bottom == 0
                          ? height * 0.8
                          : height * 0.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Hero(
                                tag: 'title',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    "CRONOLAB",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Hero(
                                tag: "emailField",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: TextFormField(
                                    controller: emailCont,
                                    style: const TextStyle(
                                        fontSize: 16, color: whiteColor),
                                    decoration: InputDecoration(
                                        label: const Text("Email"),
                                        labelStyle:
                                            const TextStyle(color: whiteColor),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: whiteColor))),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 45),
                              TextFormField(
                                controller: nomeCont,
                                style: const TextStyle(
                                    fontSize: 16, color: whiteColor),
                                decoration: InputDecoration(
                                    label: const Text("Nome"),
                                    labelStyle:
                                        const TextStyle(color: whiteColor),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: whiteColor))),
                              ),
                              const SizedBox(height: 45),
                              Hero(
                                tag: "senhaField",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: TextFormField(
                                    controller: passwordCont,
                                    style: const TextStyle(
                                        fontSize: 16, color: whiteColor),
                                    decoration: InputDecoration(
                                        label: const Text("Senha"),
                                        labelStyle:
                                            const TextStyle(color: whiteColor),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: whiteColor))),
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
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    child: loading
                                        ? CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .backgroundColor)
                                        : Text("Cadastrar",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .backgroundColor,
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
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/",
                                            ModalRoute.withName("/"));
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
                                        style: TextStyle(
                                            color: whiteColor, fontSize: 16),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Login",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                  ),
                ))));
  }
}
