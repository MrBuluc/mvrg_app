import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/const.dart';

class TextFormFieldC extends StatelessWidget {
  final Color styleColor;
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  final String? Function(String?)? validator;
  final bool? enable;
  final TextInputType? textInputType;

  const TextFormFieldC(
      {Key? key,
      required this.styleColor,
      required this.controller,
      required this.iconData,
      required this.hintText,
      required this.validator,
      this.enable,
      this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable ?? true,
      style: TextStyle(color: styleColor),
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            color: newBadgeAndEventColor,
          ),
          hintStyle: textFormFieldHintStyle,
          hintText: hintText),
      validator: validator,
    );
  }
}
