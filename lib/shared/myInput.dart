import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:cronolab/shared/colors.dart' as color;
import 'package:flutter/material.dart';

class MyField extends StatelessWidget {
  MyField({Key? key, required this.nome, this.label}) : super(key: key);

  final Widget? label;
  final TextEditingController nome;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: fonts.input,
      controller: nome,
      decoration: InputDecoration(
        fillColor: color.white.withOpacity(0.1),
        label: label,
        labelStyle: fonts.label,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
