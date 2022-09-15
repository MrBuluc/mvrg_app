import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final TextStyle? textStyle;
  const CenterText(
      {Key? key, required this.text, this.fontSize, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text!,
        style: textStyle ?? TextStyle(fontSize: fontSize ?? 14),
      ),
    );
  }
}
