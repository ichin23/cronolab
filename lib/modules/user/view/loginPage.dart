import 'package:bot_toast/bot_toast.dart';
import 'package:cronolab/modules/user/controller/loginController.dart';
import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/components/myInput.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController nome = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool cadastro = false;
  bool sumir = true;
  bool hidePassword = true;
  int select = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      SizedBox(
        width: size.width,
        height: size.height,
        child: CustomPaint(
          painter: BackgroundLogin(),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: SizedBox(
          width: size.width * 0.43,
          height: size.height,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "CRONOLAB",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 25),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        "assets/image/foreground.png",
                        height: 20,
                      ),
                    ],
                  ),
                  const Text("Controle o seu tempo",
                      style: TextStyle(color: backgroundDark, fontSize: 18)),
                  const SizedBox(height: 20),
                ]),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 40,
                        childAspectRatio: 1,
                        crossAxisSpacing: size.width * 0.05,
                        crossAxisCount: 2),
                    delegate: SliverChildListDelegate(
                      [
                        MouseRegion(
                          onHover: (ev) {
                            if (select != 0) {
                              setState(() {
                                select = 0;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: select == 0 ? primaryDark : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.alarm_on,
                                  size: (size.width * 0.28 - 100) / 3 > 100
                                      ? 100
                                      : (size.width * 0.28 - 100) / 3,
                                  color: backgroundDark,
                                ),
                                const Text(
                                  "Total controle de suas atividades",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: backgroundDark),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MouseRegion(
                          onHover: (ev) {
                            if (select != 1) {
                              setState(() {
                                select = 1;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: select == 1 ? primaryDark : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.groups,
                                  size: (size.width * 0.28 - 100) / 3 > 100
                                      ? 100
                                      : (size.width * 0.28 - 100) / 3,
                                  color: backgroundDark,
                                ),
                                const Text(
                                  "Compartilhamento de tarefas com a turma",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: backgroundDark),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MouseRegion(
                          onHover: (ev) {
                            if (select != 2) {
                              setState(() {
                                select = 2;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: select == 2 ? primaryDark : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.palette,
                                  size: (size.width * 0.28 - 100) / 3 > 100
                                      ? 100
                                      : (size.width * 0.28 - 100) / 3,
                                  color: backgroundDark,
                                ),
                                const Text(
                                  "Paleta com cores significativas e personalizáveis",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: backgroundDark),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MouseRegion(
                          onHover: (ev) {
                            if (select != 3) {
                              setState(() {
                                select = 3;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: select == 3 ? primaryDark : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.alarm_on,
                                  size: (size.width * 0.28 - 100) / 3 > 100
                                      ? 100
                                      : (size.width * 0.28 - 100) / 3,
                                  color: backgroundDark,
                                ),
                                const Text(
                                  "Total controle de suas atividades",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: backgroundDark),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 25, right: 30),
            width: size.width * 0.4,
            height: size.height * 0.9,
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Acesse sua conta agora!",
                    style: TextStyle(color: whiteColor, fontSize: 30),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: cadastro ? 1 : 0,
                    child: !sumir
                        ? MyField(
                            nome: nome,
                            maxLength: 30,
                            label: const Text("Nome"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite um nome";
                              }
                              return null;
                            },
                          )
                        : Container(),
                  ),
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
                  Column(
                    children: [
                      Hero(
                        tag: "button",
                        child: Material(
                          type: MaterialType.transparency,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                minimumSize: Size(size.width - 50, 55),
                                backgroundColor: Theme.of(context).primaryColor,
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
                              var userP = GetIt.I.get<UserProvider>();
                              print(cadastro);
                              if (cadastro) {
                                var cancel = BotToast.showLoading();

                                await userP.cadastro(
                                    nome.text, email.text, senha.text, context);
                                cancel();
                              } else {
                                var cancel = BotToast.showLoading();
                                await userP.login(
                                    email.text, senha.text, context);
                                cancel();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      (TextButton(
                          style: TextButton.styleFrom(
                              minimumSize: Size(size.width * 0.5, 55),
                              backgroundColor: whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: Row(
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16)))
                              ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
      Positioned(
          bottom: 3,
          right: 2,
          child: RichText(
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
          ))
    ]));
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

    //paint.color = Colors.red;
    //paint.strokeWidth = 2;

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width * 0.61, 0);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.14,
        size.width * 0.43, size.height / 2);
    path.quadraticBezierTo(
        size.width * 0.45, size.height * 0.83, size.width * 0.39, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
