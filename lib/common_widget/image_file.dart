import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/const.dart';

class ImageFile extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;

  const ImageFile({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  State<ImageFile> createState() => _ImageFileState();
}

class _ImageFileState extends State<ImageFile> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height * .15,
        width: size.width * .4,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: newBadgeAndEventColor,
            )),
        child: GestureDetector(
          child: Center(
            child: widget.child,
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
