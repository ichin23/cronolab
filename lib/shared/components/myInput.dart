import 'package:cronolab/shared/colors.dart' as color;
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:cronolab/shared/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyField extends StatelessWidget {
  const MyField(
      {Key? key,
      required this.nome,
      this.label,
      this.editable = true,
      this.validator,
      this.onChanged,
      this.maxLength})
      : super(key: key);

  final Widget? label;
  final int? maxLength;
  final TextEditingController nome;
  final bool editable;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: fonts.inputDark,
      enabled: editable,
      onChanged: onChanged,
      validator: validator,
      controller: nome,
      maxLength: maxLength ??
          context.read<Settings>().settings["input"]["limiteGeral"] ??
          50,
      decoration: InputDecoration(
        counterText: "",
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
