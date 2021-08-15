import 'package:flutter/material.dart';

class ComplexTransition extends StatefulWidget {
  const ComplexTransition({Key? key}) : super(key: key);

  @override
  _ComplexTransitionState createState() => _ComplexTransitionState();
}

class _ComplexTransitionState extends State<ComplexTransition>
    with SingleTickerProviderStateMixin {
  // first of all
  // the idea of the animation is two images with the same width and height
  // one of the images will be in the back and the other in the front
  // the front image will have a variable called width to controlle its width to show the
  // back image
  // i got both of the images in the assets one called black.png and the other called red.png

  late Animation<double> width;
  // define the animation with a double type because the width should be double
  late AnimationController controller;
  // define our animation controller
  @override
  initState() {
    // adding initState function
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    // this will be our animation controller
    width = Tween(begin: 0.0, end: 295.0).animate(controller);
    // this is the width that will be adjusted
    // the minimum width is zero and the maximum is 295 because there is a green line with a width 5 in the end so it's not 300
    controller.addStatusListener((status) {
      // adding a status listner to check the state and reverse the animation
      if (status == AnimationStatus.completed) {
        // checking if the animation completed
        controller.reverse();
        // revesing the animation
      }
    });
  }

  // instead of all of those complex animation you can use AnimatedContainer
  // but this is more proffision and better for the performance
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
                width: 300,
                height: 60,
                child: Stack(
                  children: [
                    Container(
                        width: 300,
                        height: 60,
                        child: Image.asset("assets/images/red.png",
                            fit: BoxFit.cover)),
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, child) => Container(
                              width: width.value,
                              height: 60,
                              child: Image.asset(
                                "assets/images/black.png",
                                fit: BoxFit.cover,
                                alignment: Alignment.centerLeft,
                              )),
                        ),
                        Container(
                          width: 5,
                          height: 80,
                          alignment: Alignment.center,
                          color: Colors.green,
                        )
                      ],
                    )
                  ],
                )),
          ),
          ElevatedButton(
              onPressed: () {
                controller.forward();
                // launching animation
                
              },
              child: Text("Start")),
        ],
      ),
    );
  }
}






