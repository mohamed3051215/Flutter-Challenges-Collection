import 'package:flutter/material.dart';
import 'package:flutter_challenges_collection/home_screen.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
        
    );
  }
}
