import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({Key? key}) : super(key: key);

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  bool loading = false;
  final _form = GlobalKey<FormState>();
  TextEditingController emailCont = TextEditingController();
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                .colorScheme
                                                .background)
                                        : Text("Recuperar Senha",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800)),
                                    onPressed: () async {
                                      if (_form.currentState!.validate()) {
                                        /*await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: emailCont.text)
                                            .then((value) =>
                                                Navigator.pop(context));*/
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ),
                ))));
  }
}
