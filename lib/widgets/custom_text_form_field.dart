import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, this.hintText, this.labelText, this.autofillHints, this.obscureText, required this.validator, this.controller, required this.onSaved});

  final String? hintText, labelText;
  final bool? obscureText;
  final List<String>? autofillHints;
  final String? Function(String?) validator;
  final TextEditingController? controller;
  final Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: true,
      autofillHints: autofillHints,
      obscureText: obscureText!,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          hintText: hintText!,
          labelText: labelText!,
          alignLabelWithHint: true),
      validator: validator,
      controller: controller,
      onSaved: onSaved,
    );
  }
}
