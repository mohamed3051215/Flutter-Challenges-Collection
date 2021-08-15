import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class FruitNinja extends StatefulWidget {
  final Size screenSize;
  final Size worldSize;

  const FruitNinja({required this.screenSize, required this.worldSize}) ;

  @override
  State<StatefulWidget> createState() => FruitNinjaState();
}

class FruitNinjaState extends State<FruitNinja> {
  Random r = Random();

  late Timer periodicFruitLauncher;

  List<PieceOfFruit> fruit = [];

  List<SlicedFruit> slicedFruit = [];

  List<Slice> slices = [];

  late int sliceBeginMoment;
  late Offset sliceBeginPosition;
  late Offset sliceEnd;

  int sliced = 0;
  int notSliced = 0;

  @override
  void initState() {
    super.initState();

    periodicFruitLauncher = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        fruit.add(PieceOfFruit(
            createdMS: DateTime.now().millisecondsSinceEpoch,
            flightPath: FlightPath(
                angle: 1.0,
                angularVelocity: .3 + r.nextDouble() * 3.0,
                position: Offset(2.0 + r.nextDouble() * (widget.worldSize.width - 4.0), 1.0),
                velocity: Offset(-1.0 + r.nextDouble() * 2.0, 7.0 + r.nextDouble() * 7.0)),
            type: FruitType.values[r.nextInt(FruitType.values.length)]));
      });
    });
  }

  @override
  void dispose() {
    if (periodicFruitLauncher != null) {
      periodicFruitLauncher.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double ppu = widget.screenSize.height / widget.worldSize.height;
    List<Widget> stackItems = [];
    for (PieceOfFruit f in fruit) {
      stackItems.add(FlightPathWidget(
        key: f.key,
        flightPath: f.flightPath,
        unitSize: f.type.unitSize,
        pixelsPerUnit: ppu,
        child: f.type.getImageWidget(ppu),
        onOffScreen: () {
          setState(() {
            fruit.remove(f);
            notSliced++;
          });
        },
      ));
    }
    for (Slice slice in slices) {
      Offset b = Offset(slice.begin.dx * ppu, (widget.worldSize.height - slice.begin.dy) * ppu);
      Offset e = Offset(slice.end.dx * ppu, (widget.worldSize.height - slice.end.dy) * ppu);
      stackItems.add(Positioned.fill(
          child: SliceWidget(
        sliceBegin: b,
        sliceEnd: e,
        sliceFinished: () {
          setState(() {
            slices.remove(slice);
          });
        },
      )));
    }
    for (SlicedFruit sf in slicedFruit) {
      stackItems.add(FlightPathWidget(
        key: sf.key,
        flightPath: sf.flightPath,
        unitSize: sf.type.unitSize,
        pixelsPerUnit: ppu,
        child: ClipPath(clipper: FruitSlicePath(sf.slice), child: sf.type.getImageWidget(ppu)),
        onOffScreen: () {
          setState(() {
            slicedFruit.remove(sf);
          });
        },
      ));
    }
    TextStyle scoreStyle = TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700);
    stackItems.add(Positioned.fill(
        child: DefaultTextStyle(
            style: scoreStyle,
            child: SafeArea(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      Text("Sliced"),
                      SizedBox(
                        height: 8,
                      ),
                      Text("$sliced")
                    ]),
                    Column(children: [
                      Text("Not Sliced"),
                      SizedBox(
                        height: 8,
                      ),
                      Text("$notSliced")
                    ])
                  ],
                )
              ],
            )))));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: stackItems,
      ),
      
      onPanDown: (DragDownDetails details) {
        sliceBeginMoment = DateTime.now().millisecondsSinceEpoch;
        sliceBeginPosition = details.localPosition;
        sliceEnd = details.localPosition;
      },
      onPanUpdate: (DragUpdateDetails details) {
        sliceEnd = details.localPosition;
      },
      onPanEnd: (DragEndDetails details) {
        int nowMS = DateTime.now().millisecondsSinceEpoch;
        if (nowMS - sliceBeginMoment < 1250 && (sliceEnd - sliceBeginPosition).distanceSquared > 25.0) {
          setState(() {
            Offset worldSliceBegin =
                Offset(sliceBeginPosition.dx / ppu, (widget.screenSize.height - sliceBeginPosition.dy) / ppu);
            Offset worldSliceEnd = Offset(sliceEnd.dx / ppu, (widget.screenSize.height - sliceEnd.dy) / ppu);
            this.slices.add(Slice(worldSliceBegin, worldSliceEnd));
            Offset direction = worldSliceEnd - worldSliceBegin;

            worldSliceBegin = worldSliceBegin - direction;
            worldSliceEnd = worldSliceEnd + direction;
            List<PieceOfFruit> toRemove = [];
            for (PieceOfFruit f in fruit) {
              double elapsedSeconds = (nowMS - f.createdMS) / 1000.0;
              Offset currPos = f.flightPath.getPosition(elapsedSeconds);
              double currAngle = f.flightPath.getAngle(elapsedSeconds);
              List<List<Offset>> sliceParts =
                  getSlicePaths(worldSliceBegin, worldSliceEnd, f.type.unitSize, currPos, currAngle);
              if (sliceParts.isNotEmpty) {
                toRemove.add(f);
                slicedFruit.add(SlicedFruit(
                    slice: sliceParts[0],
                    flightPath: FlightPath(
                        angle: currAngle,
                        angularVelocity: f.flightPath.angularVelocity - .25 + r.nextDouble() * .5,
                        position: currPos,
                        velocity: Offset(-1.0, 2.0)),
                    type: f.type));
                slicedFruit.add(SlicedFruit(
                    slice: sliceParts[1],
                    flightPath: FlightPath(
                        angle: currAngle,
                        angularVelocity: f.flightPath.angularVelocity - .25 + r.nextDouble() * .5,
                        position: currPos,
                        velocity: Offset(1.0, 2.0)),
                    type: f.type));
              }
            }
            sliced += toRemove.length;
            fruit.removeWhere((e) => toRemove.contains(e));
          });
        }
      },
    );
  }
}

class FruitSlicePath extends CustomClipper<Path> {
  final List<Offset> normalizedPoints;

  FruitSlicePath(this.normalizedPoints);

  @override
  Path getClip(Size size) {
    Path p = Path()..moveTo(normalizedPoints[0].dx * size.width, normalizedPoints[0].dy * size.height);
    for (Offset o in normalizedPoints.skip(1)) {
      p.lineTo(o.dx * size.width, o.dy * size.height);
    }
    return p..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class FruitHome extends StatelessWidget {
  const FruitHome({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Container(
                color: Colors.orange,
                child: LayoutBuilder(builder: (context, constraints) {
                  Size screenSize = Size(constraints.maxWidth, constraints.maxHeight);
                  Size worldSize = Size(WORLD_HEIGHT * screenSize.aspectRatio, WORLD_HEIGHT);
                  return FruitNinja(
                    screenSize: Size(constraints.maxWidth, constraints.maxHeight),
                    worldSize: worldSize, 
                  );
                })));
  }
}

const Offset GRAVITY = Offset(0, -9.8);
const double WORLD_HEIGHT = 16.0;

enum FruitType { apple, banana, mango, watermelon }

extension FruitTypeUtil on FruitType {
  Size get unitSize {
    switch (this) {
      case FruitType.apple:
        return Size(2.04, 2.0);
      case FruitType.banana:
        return Size(3.19, 2.0);
      case FruitType.mango:
        return Size(3.16, 2.0);
      case FruitType.watermelon:
        return Size(2.6, 2.0);
    }
  }

  String get imageFile {
    switch (this) {
      case FruitType.apple:
        return "assets/images/apple.png";
      case FruitType.banana:
        return "assets/images/banana.png";
      case FruitType.mango:
        return "assets/images/mango.png";
      case FruitType.watermelon:
        return "assets/images/watermelon.png";
    }
  }

  Widget getImageWidget(double pixelsPerUnit) =>
      Image.asset(imageFile, width: unitSize.width * pixelsPerUnit, height: unitSize.height * pixelsPerUnit);
}

class PieceOfFruit {
  final Key key = UniqueKey();
  final int createdMS;
  final FlightPath flightPath;
  final FruitType type;

  PieceOfFruit({required this.createdMS, required this.flightPath, required this.type});
}

class SlicedFruit {
  final Key key = UniqueKey();
  final List<Offset> slice;
  final FlightPath flightPath;
  final FruitType type;

  SlicedFruit({required this.slice, required this.flightPath, required this.type});
}

class Slice {
  final Key key = UniqueKey();
  final Offset begin;
  final Offset end;

  Slice(this.begin, this.end);
}

// a parabolic flight path.
// all flights in this program start below zero and fly upwards
// past zero. Therefore, there are always two zeroes.
class FlightPath {
  final double angle;
  final double angularVelocity;
  final Offset position;
  final Offset velocity;

  FlightPath({required this.angle, required this.angularVelocity, required this.position, required this.velocity});

  Offset getPosition(double t) {
    return (GRAVITY * .5) * t * t + velocity * t + position;
  }

  double getAngle(double t) {
    return angle + angularVelocity * t;
  }

  List<double> get zeroes {
    double a = (GRAVITY * .5).dy;
    double sqrtTerm = sqrt(velocity.dy * velocity.dy - 4.0 * a * position.dy);
    return [(-velocity.dy + sqrtTerm) / (2 * a), (-velocity.dy - sqrtTerm) / (2 * a)];
  }
}

class FlightPathWidget extends StatefulWidget {
  final FlightPath flightPath;

  final Size unitSize;
  final double pixelsPerUnit;

  final Widget child;

  final Function() onOffScreen;

  const FlightPathWidget({required Key key, required this.flightPath, required this.unitSize, required this.pixelsPerUnit, required this.child, required this.onOffScreen})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FlightPathWidgetState();
}

class FlightPathWidgetState extends State<FlightPathWidget> with SingleTickerProviderStateMixin {
 late AnimationController controller;

  @override
  void initState() {
    super.initState();

    List<double> zeros = widget.flightPath.zeroes;
    double time = max(zeros[0], zeros[1]);

    controller = AnimationController(
        vsync: this,
        upperBound: time + 1.0, // allow an extra second of fall time
        duration: Duration(milliseconds: ((time + 1.0) * 1000.0).round()));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onOffScreen();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        Offset pos = widget.flightPath.getPosition(controller.value) * widget.pixelsPerUnit;
        return Positioned(
          left: pos.dx - widget.unitSize.width * .5 * widget.pixelsPerUnit,
          bottom: pos.dy - widget.unitSize.height * .5 * widget.pixelsPerUnit,
          child: Transform(
            transform: Matrix4.rotationZ(widget.flightPath.getAngle(controller.value)),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: widget.child);
}

class SliceWidget extends StatefulWidget {
  final Offset sliceBegin;
  final Offset sliceEnd;
  final Function() sliceFinished;

  const SliceWidget({Key? key, required this.sliceBegin, required this.sliceEnd, required this.sliceFinished}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SliceWidgetState();
}

class SliceWidgetState extends State<SliceWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 120));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.sliceFinished();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            Offset sliceDirection = widget.sliceEnd - widget.sliceBegin;
            return CustomPaint(
                painter:
                    SlicePainter(begin: widget.sliceBegin, end: widget.sliceBegin + sliceDirection * controller.value));
          }));
}

class SlicePainter extends CustomPainter {
  final Offset begin;
  final Offset end;

  SlicePainter({required this.begin, required this.end});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()
          ..moveTo(begin.dx, begin.dy)
          ..lineTo(end.dx, end.dy),
        Paint()
          ..color = Colors.white.withAlpha(180)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(SlicePainter o) {
    return true;
  }
}



List<Offset> rotatePointsAroundPosition(
    Offset s1, Offset s2, Offset position, double boxAngle) {
  double s = sin(boxAngle);
  double c = cos(boxAngle);

  Offset local1 = s1 - position;
  Offset local2 = s2 - position;

  Offset new1 =
      Offset(local1.dx * c - local1.dy * s, local1.dx * s + local1.dy * c);
  Offset new2 =
      Offset(local2.dx * c - local2.dy * s, local2.dx * s + local2.dy * c);

  return [new1 + position, new2 + position];
}

// returns a box sliced by a line. Size of returned value will either be
// empty if there's no intersection, or will be 2 (describing the two
// polygons formed by slicing the box)
List<List<Offset>> getSlicePaths(
    Offset s1, Offset s2, Size boxSize, Offset boxPosition, double boxAngle) {
  List<Offset> rotatedPoints =
      rotatePointsAroundPosition(s1, s2, boxPosition, boxAngle);
  Offset l1 = rotatedPoints[0];
  Offset l2 = rotatedPoints[1];
  Offset dir = l2 - l1;

  // equation for line is l1 + dir * t, where t == 1.0 == l2

  Rect box = Rect.fromCenter(
      center: boxPosition, width: boxSize.width, height: boxSize.height);
  double bot = box.bottom < box.top ? box.bottom : box.top;
  double top = box.bottom < box.top ? box.top : box.bottom;

  List<Offset> path1 = [];
  List<Offset> path2 = [];

  List<Offset> currentPath = path1;

  // iterate over sides clockwise, so this alternates
  bool horizontal = false;
  for (Offset corner in [
    Offset(box.left, bot),
    Offset(box.left, top),
    Offset(box.right, top),
    Offset(box.right, bot)
  ]) {
    currentPath.add(corner);
    double t = horizontal
        ? (corner.dy - l1.dy) / dir.dy
        : (corner.dx - l1.dx) / dir.dx;
    if (t > 0 && t < 1.0) {
      var cp;
      if (horizontal) {
        double xVal = l1.dx + dir.dx * t;
        if (xVal >= box.left && xVal < box.right) {
          cp = Offset(xVal, corner.dy);
        }
      } else {
        double yVal = l1.dy + dir.dy * t;
        if (yVal >= bot && yVal < top) {
          cp = Offset(corner.dx, yVal);
        }
      }
      if (cp != null) {
        currentPath.add(cp);
        currentPath = currentPath == path1 ? path2 : path1;
        currentPath.add(cp);
      }
    }
    horizontal = !horizontal;
  }

  // normalize points
  path1 = path1
      .map((e) => Offset(
          (e.dx - box.left) / box.width, 1.0 - (e.dy - bot) / box.height))
      .toList();
  path2 = path2
      .map((e) => Offset(
          (e.dx - box.left) / box.width, 1.0 - (e.dy - bot) / box.height))
      .toList();

  return path1.length > 2 && path2.length > 2 ? [path1, path2] : [];
}
