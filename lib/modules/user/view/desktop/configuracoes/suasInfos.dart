import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

class SuasInfosDesktop extends StatefulWidget {
  const SuasInfosDesktop({Key? key}) : super(key: key);

  @override
  State<SuasInfosDesktop> createState() => _SuasInfosDesktopState();
}

class _SuasInfosDesktopState extends State<SuasInfosDesktop> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  User? user;
  getUser() async {
    user = await FirebaseAuth.instance.getUser();
    nome.text = user!.displayName ?? "";
    email.text = user!.email ?? "";
  }

  @override
  void initState() {
    super.initState();
    // nome.text = (FirebaseAuth.instance.getUser()). ?? "";
    // email.text = FirebaseAuth.instance.currentUser!.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            controller: ScrollController(),
            children: [
              TextFormField(
                controller: nome,
                style: inputDark,
                decoration: const InputDecoration(
                    label: Text("Nome"), labelStyle: labelDark),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text("Erro"),
                            content: Text("Não é possível alterar o email"),
                          ));
                },
                child: TextFormField(
                    controller: email,
                    style: inputDark,
                    enabled: false,
                    decoration: const InputDecoration(
                        label: Text("Email"), labelStyle: labelDark)),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryDark),
                      textStyle: MaterialStateProperty.all(labelDark)),
                  child: const Text(
                    "Salvar",
                    style: labelBlackDark,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          );
        });
  }
}
