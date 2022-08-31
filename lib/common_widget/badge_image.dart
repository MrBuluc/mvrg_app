import 'package:flutter/material.dart';

class BadgeImage extends StatelessWidget {
  final String id, imageUrl;
  const BadgeImage({Key? key, required this.id, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: id,
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: loadingBuilder,
        ));
  }

  Widget loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null
          ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
          : null,
    );
  }
}
