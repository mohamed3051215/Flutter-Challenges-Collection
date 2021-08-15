import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AlienPaint extends StatefulWidget {
  const AlienPaint({Key? key}) : super(key: key);

  @override
  _AlienPaintState createState() => _AlienPaintState();
}

class _AlienPaintState extends State<AlienPaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: Center(
            child: Container(
          width: 200,
          height: 200,
          child: CustomPaint(painter: _AlienPainter()),
        )));
  }
}

class _AlienPainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    final double triangleHeight = 20;
    final double triangleWidth = triangleHeight / 2;
    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height / 2);
    final Rect mainRect = Rect.fromLTWH(0, 0, 200, 200);

    final Path facePath = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height - 90)
      ..arcTo(mainRect, pi * 2, pi, true)
      ..lineTo(0, 0);
    final Path hairPath = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, 40)
      ..lineTo(width / 2 - 20, 40)
      ..lineTo((width / 2 - 20) - triangleWidth * 1, 40 + triangleHeight)
      ..lineTo((width / 2 - 20) - triangleWidth * 2, 40)
      ..lineTo((width / 2 - 20) - triangleWidth * 3, 40 + triangleHeight)
      ..lineTo((width / 2 - 20) - triangleWidth * 4, 40)
      ..lineTo((width / 2 - 20) - triangleWidth * 5, 40 + triangleHeight)
      ..lineTo((width / 2 - 20) - triangleWidth * 6, 40)
      ..lineTo((width / 2 - 20) - triangleWidth * 7, 40 + triangleHeight)
      ..lineTo((width / 2 - 20) - triangleWidth * 8, 40);

    final Rect woundRect = Rect.fromLTWH(width / 2 + 10, 60, 80, 10);
    final Rect fisrstWoundRect =
        Rect.fromLTWH(woundRect.left + woundRect.width / 3 - 10, 55, 10, 20);
    final Rect secondWoundRect = Rect.fromLTWH(
        woundRect.left + (woundRect.width / 3) * 2 + 4, 55, 10, 20);
    final Paint hairPaint = Paint()..color = Color(0xff424b54);

    final Rect leftEyeRect = Rect.fromLTWH(50, 93, 30, 30);
    final Rect rightEyeRect = Rect.fromLTWH(130, 93, 30, 30);
    final Rect moutheRect = 
    final Rect leftEyeCircle =
        Rect.fromLTWH(leftEyeRect.left + 6, leftEyeRect.top + 10, 16, 16);
    final Rect rightEyeCircle =
        Rect.fromLTWH(rightEyeRect.left + 6, rightEyeRect.top + 10, 16, 16);
    canvas.drawPath(facePath, Paint()..color = Colors.green);
    canvas.drawPath(hairPath, hairPaint);
    canvas.drawLine(
        woundRect.centerLeft,
        woundRect.centerRight,
        Paint()
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..color = Color(0xff424b54));
    canvas.drawLine(
        fisrstWoundRect.topCenter,
        fisrstWoundRect.bottomCenter,
        Paint()
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 10
          ..color = Color(0xff424b54));
    canvas.drawLine(
        secondWoundRect.topCenter,
        secondWoundRect.bottomCenter,
        Paint()
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 10
          ..color = Color(0xff424b54));
    canvas.drawCircle(leftEyeRect.center, 14, Paint()..color = Colors.white);
    canvas.drawCircle(
        leftEyeRect.center,
        15,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    canvas.drawCircle(leftEyeCircle.center, 8, Paint());
    canvas.drawCircle(rightEyeRect.center, 14, Paint()..color = Colors.white);
    canvas.drawCircle(
        rightEyeRect.center,
        15,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    canvas.drawCircle(rightEyeCircle.center, 8, Paint());
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
