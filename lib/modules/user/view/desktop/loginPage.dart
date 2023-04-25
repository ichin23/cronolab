import 'package:cronolab/modules/user/controller/loginControllerDesktop.dart';
import 'package:cronolab/modules/user/view/mobile/cadastroPage.dart';
import 'package:cronolab/modules/user/view/mobile/esqueciSenha.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';

class LoginPageDesktop extends StatefulWidget {
  const LoginPageDesktop({Key? key}) : super(key: key);

  @override
  State<LoginPageDesktop> createState() => _LoginPageDesktopState();
}

class _LoginPageDesktopState extends State<LoginPageDesktop> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController senhaCont = TextEditingController();
  FocusNode emailFoc = FocusNode();
  FocusNode senhaFoc = FocusNode();
  bool hidePassword = true;
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).padding.top +
        200;
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Form(
          key: _form,
          child: SizedBox(
            width: width,
            height: height - MediaQuery.of(context).padding.bottom,
            child: Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  /* padding: const EdgeInsets.fromLTRB(40, 100, 40, 20), */
                  width: width * 0.4,
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? height * 0.8
                      : height * 0.65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Hero(
                            tag: 'title',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                "CRONOLAB",
                                style: inputDeverDark,
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
                                autofocus: true,
                                focusNode: emailFoc,
                                onFieldSubmitted: (email) {
                                  emailFoc.unfocus();
                                  senhaFoc.requestFocus();
                                },
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
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: whiteColor))),
                              ),
                            ),
                          ),
                          const SizedBox(height: 45),
                          Hero(
                            tag: "senhaField",
                            child: Material(
                              type: MaterialType.transparency,
                              child: TextFormField(
                                controller: senhaCont,
                                focusNode: senhaFoc,
                                onFieldSubmitted: (sen) {
                                  setState(() {
                                    loading = true;
                                  });
                                  LoginControllerDesktop().loginEmail(
                                      emailCont.text, senhaCont.text, context);
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                style: const TextStyle(
                                    fontSize: 16, color: whiteColor),
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                    label: const Text("Senha"),
                                    labelStyle:
                                        const TextStyle(color: whiteColor),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                        icon: Icon(
                                          hidePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: whiteColor,
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: whiteColor))),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=> EsqueciSenha()));
                                  },
                                  child: const Text("Esqueci minha senha")),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Hero(
                            tag: "button",
                            child: Material(
                              type: MaterialType.transparency,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: Size(width - 50, 55),
                                    backgroundColor: primaryDark,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: backgroundDark, strokeWidth: 3)
                                    : const Text("Login",
                                        style: TextStyle(
                                            color: backgroundDark,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800)),
                                onPressed: loading
                                    ? () {}
                                    : () {
                                        setState(() {
                                          loading = true;
                                        });
                                        LoginControllerDesktop().loginEmail(
                                            emailCont.text,
                                            senhaCont.text,
                                            context);
                                        setState(() {
                                          loading = false;
                                        });
                                      },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 85),
                          Hero(
                            tag: "conta",
                            child: Material(
                              type: MaterialType.transparency,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Não possui conta?",
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 16),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CadastroPage()));

                                      },
                                      child: const Text("Cadastre-se",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: primaryDark,
                                              fontSize: 16)))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
