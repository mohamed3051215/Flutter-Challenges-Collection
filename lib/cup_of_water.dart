import 'dart:math';
import 'package:flutter/material.dart';

class CupOfWater extends StatefulWidget {
  const CupOfWater({Key? key}) : super(key: key);

  @override
  _CupOfWaterState createState() => _CupOfWaterState();
}

class _CupOfWaterState extends State<CupOfWater> {
  double skew = .5;
  // this is a value to make the cup 3D
  double waterFill = .5;
  // this is the fullness of the water in the cup
  double ratio = .5;
  // this is the ratio betwenn the upper oval and the other oval
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Cup Of Water Challenge",
              style: TextStyle(color: Colors.black, fontSize: 30)),
          SizedBox(
            height: 40,
          ),
          Container(
              width: 200,
              height: 300,
              child: CustomPaint(
                  // adding a custom paint
                  painter: CupPainter(
                      skew: skew, watersFill: waterFill, ratio: ratio))),
          Slider(
              // slider to controlle the skew value
              min: 0,
              max: 1,
              value: skew,
              onChanged: (double? skw) {
                setState(() {
                  skew = skw ?? 0;
                });
              }),
          Slider(
              // slider to controlle the waterFill (fullness) value

              min: 0,
              max: 1,
              value: waterFill,
              onChanged: (double? wa) {
                setState(() {
                  waterFill = wa ?? 0;
                });
              }),
          Slider(
              // slider to controlle the ratio value

              min: 0,
              max: 1,
              value: ratio,
              onChanged: (double? wa) {
                setState(() {
                  ratio = wa ?? 0;
                });
              })
        ],
      ),
    );
  }
}

class CupPainter extends CustomPainter {
  final double watersFill;
  final double skew;
  final double ratio;
  CupPainter(
      {required this.ratio, required this.watersFill, required this.skew});
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    // making width and height and center in an easy variables to get it easy
    final Rect topRect = Rect.fromLTWH(0, 0, w, 100 * skew);
    // this is the rectangle of the top oval taken from left , top  , width and height
    final Rect bottomRect = Rect.fromLTWH((w / 2 - (w - 50 * ratio) / 2),
        h - 30 * skew, w - 50 * ratio, 30 * skew);
    // this is the botom rect for the bottom oval
    final Rect waterFillRect =
        Rect.lerp(topRect, bottomRect, watersFill) ?? Rect.zero;
    // this is the fulness rect and it's from lerp
    // lero is giving you rect between two rects
    //and the third parameter is the ratio between th two rects
    final Rect waterTopRect =
        Rect.lerp(topRect, bottomRect, watersFill) ?? Rect.zero;
    // this is for the top oval of the water
    canvas.drawPath(
        Path()
          ..moveTo(topRect.centerLeft.dx, topRect.centerLeft.dy)
          ..arcTo(topRect, pi, 3, true)
          ..lineTo(bottomRect.centerRight.dx, bottomRect.centerRight.dy)
          ..arcTo(bottomRect, pi * 2, 3, true)
          ..lineTo(topRect.centerLeft.dx, topRect.centerLeft.dy),
        Paint()..color = Colors.white.withOpacity(0.4));

    // this step is drawing the cup shapeusing path

    canvas.drawOval(topRect, Paint()..color = Colors.white.withOpacity(.5));
    // drawing the top oval of the cup
    canvas.drawPath(
        Path()
          ..moveTo(waterFillRect.centerLeft.dx,
              waterFillRect.centerLeft.dy + waterFillRect.centerLeft.dy)
          ..arcTo(waterFillRect, pi, 3, true)
          ..lineTo(bottomRect.centerRight.dx, bottomRect.centerRight.dy)
          ..arcTo(bottomRect, pi * 2, 3, true)
          ..lineTo(waterFillRect.centerLeft.dx, waterFillRect.centerLeft.dy),
        Paint()..color = Colors.blue);
    // this is to draw the water in the cup
    canvas.drawOval(
        waterTopRect, Paint()..color = Colors.white.withOpacity(.5));
    // this is to show up the top oval of the water

    /////////////////////// I HOPE YOU ENJOYED ///////////////////////////
  }

  bool shouldRepaint(_) {
    return true;
  }
}
