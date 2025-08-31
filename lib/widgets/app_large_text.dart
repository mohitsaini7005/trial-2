import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppLargeText extends StatelessWidget {
  double size;
  final String text;
  final Color color;

  AppLargeText(this.text, this.color, {super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
