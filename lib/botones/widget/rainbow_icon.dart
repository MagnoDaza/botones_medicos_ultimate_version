import 'package:flutter/material.dart';

class RainbowIcon extends StatelessWidget {
  final IconData iconData;

  RainbowIcon({required this.iconData});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: Icon(iconData, color: Colors.white),
    );
  }
}
