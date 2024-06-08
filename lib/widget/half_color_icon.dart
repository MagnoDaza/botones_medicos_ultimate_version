import 'package:flutter/material.dart';

class HalfColorIcon extends StatelessWidget {
  final IconData icon;
  final Color color1;
  final Color color2;
  final double size;

  const HalfColorIcon(
      {required this.icon,
      required this.color1,
      required this.color2,
      this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 29,
          width: 29,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade600, //color del borde aquí
              width: 1.0, //  ancho del borde aquí
            ),
          ),
          child: Icon(icon, color: color1, size: size),
        ),
        ClipRect(
          clipper: HalfClipper(),
          child: Icon(icon, color: color2, size: size),
        ),
      ],
    );
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
