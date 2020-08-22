import 'dart:async';

import 'clock_dial_painter.dart';
import 'clock_hands.dart';
import 'clock_text.dart';
import 'package:flutter/material.dart';
import 'clock_face.dart';

typedef TimeProducer = DateTime Function();

class Clock extends StatefulWidget {
  final Color circleColor;
  final Color shadowColor;

  final ClockText clockText;

  final TimeProducer getCurrentTime;
  final Duration updateDuration;

  Clock(
      {this.circleColor = const Color(0xfffe1ecf7),
      this.shadowColor = const Color(0xffd9e2ed),
      this.clockText = ClockText.arabic,
      this.getCurrentTime = getSystemTime,
      this.updateDuration = const Duration(seconds: 1)});

  static DateTime getSystemTime() {
    return new DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    return _Clock();
  }
}

class _Clock extends State<Clock> {
  Timer _timer;
  DateTime dateTime;
  static String time;//pyz
  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();
    this._timer = new Timer.periodic(widget.updateDuration, setTime);
    time = dateTime.toString().substring(11,19);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
      time = dateTime.toString().substring(11,19);//pyz
      //print(time);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 1.0,
      child: buildClockCircle(context),
    );


  }

  Container buildClockCircle(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          new BoxShadow(
            offset: new Offset(0.0, 5.0),
            blurRadius: 0.0,
            color: widget.shadowColor,
          ),
          BoxShadow(
              offset: Offset(0.0, 5.0),
              color: widget.circleColor,
              blurRadius: 10,
              spreadRadius: -8)
        ],
      ),
      child: Stack(
        children: <Widget>[
          new ClockFace(
            clockText: widget.clockText,
            dateTime: dateTime,
          ),
          Container(
            padding: EdgeInsets.all(25),
            width: double.infinity,
            child: new CustomPaint(
              painter: new ClockDialPainter(clockText: widget.clockText),
            ),
          ),
          new ClockHands(dateTime: dateTime),
        ],

      ),

    );
  }
}

class NumClock extends StatefulWidget {

  final Duration updateDuration;
  NumClock({this.updateDuration = const Duration(seconds: 1)});

  static DateTime getSystemTime() {
    return new DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    return _NumClock();
  }
}

class _NumClock extends State<NumClock> {

  Timer _timer;
  DateTime dateTime;
  static String time;//pyz
  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();
    this._timer = new Timer.periodic(widget.updateDuration, setTime);
    time = dateTime.toString().substring(11,19);
  }
  void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
      time = dateTime.toString().substring(11,19);//pyz
      //print(time);
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "\t\t\t  当前时间",
                  style: TextStyle(
                      color: Color(0xffff0863),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "$time",
                  style: TextStyle(
                      color: Color(0xff2d386b),
                      fontSize: 30,
                      fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),

          ],
        );
  }
}