import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/user/controller/loginController.dart';
import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/components/myInput.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:get_it/get_it.dart';

class LoginPageMobile extends StatefulWidget {
  const LoginPageMobile({Key? key}) : super(key: key);

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController nome = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool hidePassword = true;
  bool loading = false;
  bool cadastro = false;
  bool sumir = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                height: size.height,
                width: size.width,
                child: CustomPaint(painter: BackgroundLogin())),
            Form(
              key: _form,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.3),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: cadastro ? 1 : 0,
                      child: Visibility(
                        visible: !sumir,
                        child: MyField(
                          nome: nome,
                          maxLength: 30,
                          label: const Text("Nome"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Digite um nome";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyField(
                      nome: email,
                      label: const Text("Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Digite um email";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return "Digite um email válido";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: senha,
                        style: inputDark,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          label: const Text("Senha"),
                          labelStyle: labelDark,
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
                              borderRadius: BorderRadius.circular(8)),
                        )),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Hero(
                          tag: "button",
                          child: Material(
                            type: MaterialType.transparency,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  minimumSize: Size(size.width - 50, 55),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child: Text(cadastro ? "Cadastrar" : "Login",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800)),
                              onPressed: () async {
                                if (!_form.currentState!.validate()) return;

                                var cancel = BotToast.showLoading();
                                await GetIt.I
                                    .get<UserProvider>()
                                    .login(email.text, senha.text, context);
                                cancel();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        (TextButton(
                            style: TextButton.styleFrom(
                                minimumSize: Size(size.width - 50, 55),
                                backgroundColor: whiteColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/image/google.png",
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text("Entrar com Google",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              var cancel = BotToast.showLoading();
                              await LoginController().loginGoogle(context);
                              cancel();
                            })),
                      ],
                    ),
                    Hero(
                      tag: "conta",
                      child: Material(
                        type: MaterialType.transparency,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: cadastro
                              ? [
                                  const Text(
                                    "Já possui conta?",
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 16),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          cadastro = false;
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 300),
                                            () => setState).then((a) {
                                          a(() {
                                            sumir = true;
                                          });
                                        });
                                      },
                                      child: Text("Logar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16)))
                                ]
                              : [
                                  const Text(
                                    "Não possui conta?",
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 16),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          cadastro = true;
                                          sumir = false;
                                        });
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
                    ),
                    const Spacer(),
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: "Ao continuar, você concorda com os ",
                            style: TextStyle(color: whiteColor, fontSize: 14)),
                        TextSpan(
                            text: "Termos de Uso",
                            style: TextStyle(color: primaryDark),
                            mouseCursor: SystemMouseCursors.click),
                        TextSpan(text: ".")
                      ]),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.width * 0.1,
              child: SizedBox(
                width: size.width,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "CRONOLAB",
                      style: TextStyle(
                          color: backgroundDark,
                          fontWeight: FontWeight.w900,
                          fontSize: 25),
                    ),
                    Text(
                      "Acesse sua conta agora!",
                      style: TextStyle(color: whiteColor, fontSize: 20),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BackgroundLogin extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    paint.shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height),
        [const Color(0xff52A8FA), const Color(0xffADD6FF)]);

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.25,
        size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.17, 0, size.height * 0.3);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
