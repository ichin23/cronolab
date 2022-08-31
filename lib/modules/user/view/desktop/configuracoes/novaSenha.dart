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
    return ListView(
      children: [
        TextFormField(
          controller: senha,
          style: input,
          decoration: const InputDecoration(
              label: Text("Nova Senha"), labelStyle: label),
        ),
        TextFormField(
            controller: senhaConfirm,
            style: input,
            decoration: const InputDecoration(
                label: Text("Confirmar Senha"), labelStyle: label)),
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
