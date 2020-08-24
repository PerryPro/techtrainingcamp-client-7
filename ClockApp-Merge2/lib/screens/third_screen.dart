import 'package:flutter/material.dart';
import 'package:clock_app/timer/timer.dart';

class ThirdTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BasicAppBarSample(),
    );
  }
}
