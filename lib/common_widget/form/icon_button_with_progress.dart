import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/const.dart';

class IconButtonWithProgress extends StatefulWidget {
  final bool isProgress;
  final Future Function() onTap;
  final IconData iconData;
  const IconButtonWithProgress(
      {Key? key,
      required this.isProgress,
      required this.onTap,
      required this.iconData})
      : super(key: key);

  @override
  State<IconButtonWithProgress> createState() => _IconButtonWithProgressState();
}

class _IconButtonWithProgressState extends State<IconButtonWithProgress> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: butonBorder,
            gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                stops: [
                  .1,
                  .8
                ],
                colors: [
                  Color.fromRGBO(30, 227, 167, 1),
                  Color.fromRGBO(220, 247, 239, 1)
                ])),
        height: size.height * .08,
        width: size.width * .15,
        child: Icon(
          widget.isProgress ? Icons.lock : widget.iconData,
          color: Colors.white,
          size: 40,
        ),
      ),
      onTap: () {
        if (!widget.isProgress) {
          widget.onTap();
        }
      },
    );
  }
}
