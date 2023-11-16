import 'package:flutter/material.dart';

class TextfeildWidget extends StatelessWidget {
  const TextfeildWidget({
    Key? key,
    this.validator,
    required this.text,
    this.icon,
    this.controller,
    this.keyboardType,
    this.suffixIcon,
    this.autovalidateMode,
    this.border,
    this.prefixIcon,
    this.readOnly,
    this.maxLength,
  }) : super(key: key);

  final String? Function(String?)? validator;
  final String text;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final AutovalidateMode? autovalidateMode;
  final InputBorder? border;
  final bool? readOnly;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        maxLength: maxLength,
        readOnly: readOnly ?? false,
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
          hintText: text,
          hintStyle: const TextStyle(fontSize: 14),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          // border: border,
        ),
      ),
    );
  }
}
