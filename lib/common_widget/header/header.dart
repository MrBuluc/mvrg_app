import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/const.dart';

class Header extends StatefulWidget {
  final Color containerColor;
  final double? columnBottomPadding;
  final String text;
  const Header(
      {Key? key,
      required this.containerColor,
      this.columnBottomPadding,
      required this.text})
      : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * .3,
      decoration: BoxDecoration(
          color: widget.containerColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Padding(
        padding: EdgeInsets.only(
            left: size.width * .1, bottom: widget.columnBottomPadding ?? 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: headerText,
            )
          ],
        ),
      ),
    );
  }
}
