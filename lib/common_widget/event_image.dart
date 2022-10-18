import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final double borderRadius;
  final Object heroTag;
  final String imageUrl;
  final double? height;
  final double? width;
  const EventImage(
      {Key? key,
      required this.borderRadius,
      required this.heroTag,
      required this.imageUrl,
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
            image: imageUrl,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ));
  }
}
