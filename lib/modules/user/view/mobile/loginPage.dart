import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/user/controller/loginController.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cadastroPage.dart';
import 'esqueciSenha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController senhaCont = TextEditingController();
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
      body: SafeArea(
        child: Form(
          key: _form,
          child: SizedBox(
            width: width,
            height: height - MediaQuery.of(context).padding.bottom,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  /* padding: const EdgeInsets.fromLTRB(40, 100, 40, 20), */
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
                              child: Text("CRONOLAB",
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EsqueciSenha()));
                                  },
                                  child: const Text("Esqueci minha senha")),
                            ],
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
                                            .colorScheme
                                            .background,
                                        strokeWidth: 3)
                                    : Text("Login",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800)),
                                onPressed: () async {
                                  var cancel = BotToast.showLoading();
                                  await LoginController().loginEmail(
                                      emailCont.text, senhaCont.text, context);
                                  cancel();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          (
                              //Platform.isLinux
                              false
                                  ? Container()
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                          minimumSize: Size(width - 50, 55),
                                          backgroundColor: whiteColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/image/google.png",
                                            height: 30,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text("Entrar com Google",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w800)),
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        var cancel = BotToast.showLoading();
                                        await LoginController()
                                            .loginGoogle(context);

                                        //await context.read<Turmas>().turmasFB.loadTurmasUser();
                                        // for (var turma in context.read<Turmas>().turmasFB.turmas){
                                        //   context.read<Turmas>().turmasSQL.createFullTurma(turma);
                                        // }
                                        cancel();
                                      })),
                          const SizedBox(height: 20),
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
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CadastroPage()));
                                      },
                                      child: Text("Cadastre-se",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .primaryColor,
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
