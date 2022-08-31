import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuasInfosDesktop extends StatefulWidget {
  const SuasInfosDesktop({Key? key}) : super(key: key);

  @override
  State<SuasInfosDesktop> createState() => _SuasInfosDesktopState();
}

class _SuasInfosDesktopState extends State<SuasInfosDesktop> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  @override
  void initState() {
    super.initState();
    nome.text = FirebaseAuth.instance.currentUser!.displayName ?? "";
    email.text = FirebaseAuth.instance.currentUser!.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          controller: nome,
          style: input,
          decoration:
              const InputDecoration(label: Text("Nome"), labelStyle: label),
        ),
        InkWell(
          onTap: () {
            Get.dialog(const AlertDialog(
              title: Text("Erro"),
              content: Text("Não é possível alterar o email"),
            ));
          },
          child: TextFormField(
              controller: email,
              style: input,
              enabled: false,
              decoration: const InputDecoration(
                  label: Text("Email"), labelStyle: label)),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primary),
                textStyle: MaterialStateProperty.all(label)),
            child: const Text(
              "Salvar",
              style: labelBlack,
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
