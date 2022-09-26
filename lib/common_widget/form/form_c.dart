import 'package:flutter/material.dart';

class FormC extends StatefulWidget {
  final double top, height, width;
  final GlobalKey formKey;
  final Widget child;
  const FormC(
      {Key? key,
      required this.top,
      required this.height,
      required this.formKey,
      required this.child,
      required this.width})
      : super(key: key);

  @override
  State<FormC> createState() => _FormCState();
}

class _FormCState extends State<FormC> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Positioned(
      top: widget.top,
      right: size.width * .1,
      left: size.width * .1,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ]),
        child: widget.child,
      ),
    );
  }
}
