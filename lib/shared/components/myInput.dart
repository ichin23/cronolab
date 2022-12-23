import 'package:cronolab/shared/colors.dart' as color;
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';

class MyField extends StatelessWidget {
  const MyField(
      {Key? key, required this.nome, this.label, this.editable = true})
      : super(key: key);

  final Widget? label;
  final TextEditingController nome;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: fonts.inputDark,
      enabled: editable,
      controller: nome,
      decoration: InputDecoration(
        fillColor: color.whiteColor.withOpacity(0.1),
        label: label,
        labelStyle: fonts.labelDark,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
