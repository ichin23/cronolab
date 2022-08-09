import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

cadastraDeverDesktop(BuildContext context, DateTime data) async {
  DateFormat date = DateFormat("dd/MM");
  print(date.format(data));
  await Get.dialog(
      //context: context,
      Dialog(
    backgroundColor: black,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration:
          BoxDecoration(color: black, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Cadastrar Matéria para o dia: ${date.format(data)}",
              style: fonts.label),
          const SizedBox(height: 15),
          TextFormField(
              decoration: InputDecoration(
                  label: const Text("Título"),
                  icon: const Icon(Icons.border_color, color: white),
                  labelStyle: fonts.input,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ))),
          const SizedBox(height: 15),
          TextFormField(
              decoration: InputDecoration(
                  label: const Text("Matéria"),
                  icon: const Icon(Icons.border_color, color: white),
                  labelStyle: fonts.input,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ))),
          const SizedBox(height: 15),
          TextFormField(
              decoration: InputDecoration(
                  label: const Text("Valor/Pontuação"),
                  icon: const Icon(Icons.border_color, color: white),
                  labelStyle: fonts.input,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ))),
          const SizedBox(height: 15),
          TextFormField(
              decoration: InputDecoration(
                  label: const Text("Local"),
                  icon: const Icon(Icons.border_color, color: white),
                  labelStyle: fonts.input,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ))),
          const SizedBox(height: 15),
          TextButton(onPressed: () {}, child: const Text("Cadastra"))
        ],
      ),
    ),
  ));
}
