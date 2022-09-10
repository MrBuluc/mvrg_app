import 'package:flutter/material.dart';
import 'package:mvrg_app/model/badges/badge.dart';

class BadgeImage extends StatelessWidget {
  final Badge badge;
  const BadgeImage({Key? key, required this.badge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: badge.id!,
        child: Image.network(
          badge.imageUrl!,
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
