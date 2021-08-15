import 'dart:math';

import 'package:flutter/material.dart';

class HumanPaint extends StatefulWidget {
  State createState() => _HumanPaintState();
}

class _HumanPaintState extends State<HumanPaint> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
          child: Container(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: _HumanPainter(),
        ),
      )),
    );
  }
}

class _HumanPainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height / 2);

    final Rect centerRect =
        Rect.fromCenter(center: center, width: width, height: height);

    final Rect hairRect = Rect.fromLTWH(
        width / 3 - 10, height / 3 + 40, width / 3 + 20, height / 2 + 20);

    final Rect radiusHairRect = Rect.fromLTRB(
        hairRect.left, hairRect.top - 50, hairRect.right, hairRect.top);
    final Rect bottomFaceRect = Rect.fromLTWH(
        radiusHairRect.left + 20,
        radiusHairRect.bottom + 44,
        ((radiusHairRect.right - 20) - (radiusHairRect.left + 20)).abs(),
        50);
    final Path facePath = Path()
      ..moveTo(radiusHairRect.left + 20, radiusHairRect.bottom)
      ..lineTo(radiusHairRect.right - 20, radiusHairRect.bottom)
      ..lineTo(radiusHairRect.right - 20, radiusHairRect.bottom + 70)
      ..arcTo(bottomFaceRect, pi * 2, pi, true)
      ..lineTo(radiusHairRect.left + 20, radiusHairRect.bottom);

    final Rect rightHairBall = Rect.fromLTRB(radiusHairRect.left + 60,
        radiusHairRect.top + 20, radiusHairRect.right, radiusHairRect.bottom);
    final Rect leftHairBall = Rect.fromLTRB(
        radiusHairRect.left + 15,
        radiusHairRect.top + 20,
        radiusHairRect.right - 30,
        radiusHairRect.bottom + 16);
    final Rect rightEyesRect = Rect.fromLTRB(
        radiusHairRect.left + 50,
        radiusHairRect.bottom + 120,
        radiusHairRect.right - 7,
        radiusHairRect.bottom - 50);
    final Rect rightEyesHair = Rect.fromLTRB(rightEyesRect.left + 20,
        rightEyesRect.top - 23, rightEyesRect.right - 20, rightEyesRect.bottom);
    final Rect rightShyOval = Rect.fromLTRB(
        rightEyesHair.left + 3,
        rightEyesHair.top - 40,
        rightEyesHair.right - 3,
        rightEyesRect.bottom + 96);

    final Rect leftEyeRect = Rect.fromLTRB(
        radiusHairRect.left - 30,
        radiusHairRect.bottom + 120,
        radiusHairRect.right - 7,
        radiusHairRect.bottom - 50);
    final Rect leftEyeHair = Rect.fromLTRB(leftEyeRect.left + 60,
        leftEyeRect.top - 17, leftEyeRect.right - 60, leftEyeRect.bottom - 7);

    final Rect leftShyOval = Rect.fromLTRB(leftEyeHair.left + 3,
        leftEyeHair.top - 45, leftEyeHair.right - 3, leftEyeRect.bottom + 95);

    final Rect noseRect =
        Rect.fromLTWH(leftEyeRect.right - 55, leftEyeRect.top - 86, 10, 20);
    final Rect topNose = Rect.fromLTRB(
        noseRect.left, noseRect.top - 30, noseRect.right, noseRect.bottom - 20);
    final Rect bottomNose = Rect.fromLTRB(noseRect.left, noseRect.bottom - 0,
        noseRect.right, noseRect.bottom - 10);

    final Rect mouthRect =
        Rect.fromLTWH(leftEyeRect.right - 70, leftEyeRect.top - 75, 40, 40);
    final Rect topTongue = Rect.fromLTRB(mouthRect.left + 5, mouthRect.top + 25,
        mouthRect.right - 5, mouthRect.bottom);
    final Rect bottomTongue =
        Rect.fromLTWH(topTongue.left, topTongue.top, 30, 20);

    final Rect neckRect = Rect.fromLTWH(bottomFaceRect.bottomCenter.dx + 3,
        bottomFaceRect.bottomCenter.dy - 5, 20, 20);
    final Rect tShirtRect = Rect.fromLTWH(
        neckRect.bottomCenter.dx - 7, neckRect.bottomCenter.dy, 100, 100);
    final Paint mainCirlcePaint = Paint()..color = Colors.orangeAccent.shade200;
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final Paint backGroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.orange
      ..strokeWidth = 93;
    final Paint facePaint = Paint()..color = Color(0xffE8BEAC);
    final Paint hairPaint = Paint()..color = Color(0xff424b54);

    canvas.drawCircle(center, 130, mainCirlcePaint);
    canvas.drawRect(hairRect, hairPaint);
    canvas.drawCircle(tShirtRect.centerLeft, 50, Paint()..color = Colors.red);
    canvas.drawCircle(center, 180, backGroundPaint);
    canvas.drawCircle(center, 132, borderPaint);
    canvas.drawCircle(
        radiusHairRect.bottomCenter, radiusHairRect.width / 2, hairPaint);
    canvas.drawPath(facePath, facePaint);
    canvas.drawCircle(rightHairBall.center, 27, hairPaint);
    canvas.drawArc(leftHairBall, pi * 2, pi, true, hairPaint);
    canvas.drawCircle(rightEyesRect.center, 7, hairPaint);
    canvas.drawLine(rightEyesHair.centerLeft, rightEyesHair.centerRight,
        Paint()..strokeWidth = 3..color = Color(0xff424b54));
    canvas.drawOval(
        rightShyOval, Paint()..color = Colors.pink.shade200.withOpacity(.7));
    canvas.drawCircle(leftEyeRect.center, 7, hairPaint);
    canvas.drawLine(leftEyeHair.centerLeft, leftEyeHair.centerRight,
        Paint()..strokeWidth = 3 ..color = Color(0xff424b54));
    canvas.drawOval(
        leftShyOval, Paint()..color = Colors.pink.shade200.withOpacity(.7));
    canvas.drawRect(noseRect, Paint()..color = Colors.pink.shade200.withOpacity(.7));
    canvas.drawCircle(topNose.bottomCenter, 5, Paint()..color = Colors.pink.shade200.withOpacity(.7));
    canvas.drawCircle(bottomNose.topCenter, 5, Paint()..color = Colors.pink.shade200.withOpacity(.7));
    canvas.drawArc(mouthRect, pi * 2, pi, true, hairPaint);
    canvas.drawArc(topTongue, pi * 2, pi, true, Paint()..color = Colors.red);
    canvas.drawArc(bottomTongue, pi, pi, true, Paint()..color = Colors.red);
    canvas.drawCircle(neckRect.centerLeft, 15, Paint()..color = facePaint.color);
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
