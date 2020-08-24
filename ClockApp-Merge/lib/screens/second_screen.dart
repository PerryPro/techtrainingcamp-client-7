import 'package:flutter/material.dart';
import 'package:clock_app/alarm/alarm.dart';

class SecondTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Alarm(title: '闹钟'),
    );

  }
}
