import 'package:flutter/material.dart';

import '../../ui/const.dart';

class HeaderWithRow extends StatefulWidget {
  final Color containerColor;
  final String text;
  final double? fontSize;
  final List<Widget> children;

  const HeaderWithRow({
    Key? key,
    required this.containerColor,
    required this.text,
    required this.children,
    this.fontSize,
  }) : super(key: key);

  @override
  State<HeaderWithRow> createState() => _HeaderWithRowState();
}

class _HeaderWithRowState extends State<HeaderWithRow> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .25,
      decoration: BoxDecoration(
          color: widget.containerColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 7)
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: size.width * .05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.text,
              style: headerText.copyWith(fontSize: widget.fontSize),
              textAlign: TextAlign.center,
            ),
            Column(
              children: widget.children,
            ),
          ],
        ),
      ),
    );
  }
}
