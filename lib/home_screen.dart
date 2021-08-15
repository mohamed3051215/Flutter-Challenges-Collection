import 'package:flutter/material.dart';
import 'package:flutter_challenges_collection/alien_paint.dart';
import 'package:flutter_challenges_collection/complex_transition.dart';
import 'package:flutter_challenges_collection/cup_of_water.dart';
import 'package:flutter_challenges_collection/f_set.dart';
import 'package:flutter_challenges_collection/fruit_ninja.dart';
import 'package:flutter_challenges_collection/human_paint.dart';
import 'package:flutter_challenges_collection/pokymon_paint.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(child: Text("")),
          Text("Welcome To, \n FLutter Challenges",
              style: TextStyle(color: Colors.black, fontSize: 40)),
          Expanded(
            child: Center(
              child: ListView(
                children: [
                  ChallengeTile(
                      text: "Complex Transition", screen: ComplexTransition()),
                  ChallengeTile(text: "Cup Of Water", screen: CupOfWater()),
                  ChallengeTile(text: "Fruit Ninja", screen:  FruitHome()),
                  ChallengeTile(text: "Shapes", screen: SetHome()),
                  ChallengeTile(text: "Human Paint", screen: HumanPaint()),
                  ChallengeTile(text: "Pokymon Paint", screen: PokyPaint()),
                  ChallengeTile(text: "Alien Paint", screen: AlienPaint()),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeTile extends StatelessWidget {
  final String text;
  final Widget screen;

  const ChallengeTile({Key? key, required this.text, required this.screen})
      : super(key: key);
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Colors.white,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
        title: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
