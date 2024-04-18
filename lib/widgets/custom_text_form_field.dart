import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, this.hintText, this.labelText, this.autofillHints, this.obscureText, this.validator, this.controller, this.onSaved, this.initialValue, this.enabled = true});

  final String? hintText, labelText;
  final String? initialValue;
  final bool? obscureText;
  final List<String>? autofillHints;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: true,
      autofillHints: autofillHints,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          hintText: hintText,
          labelText: labelText!,
          alignLabelWithHint: true),
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      obscureText: obscureText!,
      initialValue: initialValue,
      enabled: enabled,
    );
  }
}
