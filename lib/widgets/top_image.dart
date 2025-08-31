import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  final double size;
  const TopImage({
    super.key,
    required this.imgPath, required this.size,
  });

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imgPath,
      height: size,
      width: size,
    );
  }
}
