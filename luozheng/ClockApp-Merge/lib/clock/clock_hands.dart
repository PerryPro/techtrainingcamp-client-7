import 'dart:async';
import 'clock_hands_painter.dart';
import 'package:flutter/material.dart';



class ClockHands extends StatelessWidget {//绘制指针
  final DateTime dateTime;
  final bool showHourHandleHeartShape;

  ClockHands({this.dateTime, this.showHourHandleHeartShape = false});

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: new Stack(
                fit: StackFit.expand, 
                children: <Widget>[
                  new CustomPaint(painter: new HourHandPainter(
                      hours: dateTime.hour, minutes: dateTime.minute),
                  ),
                  new CustomPaint(painter: new MinuteHandPainter(
                      minutes: dateTime.minute, seconds: dateTime.second),
                  ),
                  new CustomPaint(painter: new SecondHandPainter(seconds: dateTime.second),
                  ),
                ]
            )
        )

    );
  }
}
