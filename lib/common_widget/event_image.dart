import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final double borderRadius;
  final Object heroTag;
  final String image;
  final double? height;
  final double? width;
  const EventImage(
      {Key? key,
      required this.borderRadius,
      required this.heroTag,
      required this.image,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: FadeInImage.assetNetwork(
            placeholder: "assets/loading.gif",
            image: image,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ));
  }
}
