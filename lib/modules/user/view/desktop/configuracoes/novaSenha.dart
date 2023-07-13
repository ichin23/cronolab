import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';

class AlteraSenha extends StatefulWidget {
  const AlteraSenha({Key? key}) : super(key: key);

  @override
  State<AlteraSenha> createState() => _AlteraSenhaState();
}

class _AlteraSenhaState extends State<AlteraSenha> {
  late TextEditingController senha;
  late TextEditingController senhaConfirm;

  @override
  void initState() {
    super.initState();
    senha = TextEditingController();
    senhaConfirm = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView(
        controller: ScrollController(),
        children: [
          TextFormField(
            controller: senha,
            style: inputDark,
            decoration: const InputDecoration(
                label: Text("Nova Senha"), labelStyle: labelDark),
          ),
          const SizedBox(height: 8),
          TextFormField(
              controller: senhaConfirm,
              style: inputDark,
              decoration: const InputDecoration(
                  label: Text("Confirmar Senha"), labelStyle: labelDark)),
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
      ),
    );
  }
}
