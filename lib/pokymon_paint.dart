import 'dart:math';

import 'package:flutter/material.dart';

class PokyPaint extends StatefulWidget {
  State createState() => _PokyPaintState();
}

class _PokyPaintState extends State<PokyPaint> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: _PokymonPainter(),
          ),
        ),
      ),
    );
  }
}

class _PokymonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);

    final Rect redArcRect = Rect.fromLTWH(0, 0, w, h);
    final Rect whiteArcRect = Rect.fromLTWH(0, 0, w, h);
    final Rect midLineRect =
        Rect.lerp(redArcRect, whiteArcRect, .5) ?? Rect.zero;
    canvas.drawArc(redArcRect, pi, pi, false, Paint()..color = Colors.red.shade900);
    canvas.drawArc(
        whiteArcRect, pi * 2, pi, false, Paint()..color = Colors.white);
    canvas.drawLine(
        midLineRect.centerLeft,
        midLineRect.centerRight,
        Paint()
          ..color = Colors.black
          ..strokeWidth = 15);
    canvas.drawCircle(
        center,
        50,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 13);
    canvas.drawCircle(center, 44, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      30,
      Paint()..color = Colors.red.shade900
    );
  }

  bool shouldRepaint(CustomPainter oldDelegeta) {
    return true;
  }
}
