import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  const CenterText({Key? key, required this.text, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text!,
        style: TextStyle(fontSize: fontSize ?? 14),
      ),
    );
  }
}
