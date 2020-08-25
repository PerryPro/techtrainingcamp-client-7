import 'dart:async';

import 'clock_dial_painter.dart';
import 'clock_hands.dart';
import 'package:flutter/material.dart';
import 'clock_face.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef TimeProducer = DateTime Function();

class Clock extends StatefulWidget {//模拟时钟
  final Color circleColor;
  final Color shadowColor;
  final TimeProducer getCurrentTime;
  final Duration updateDuration;

  Clock(
      {this.circleColor = const Color(0xfffe1ecf7),
      this.shadowColor = const Color(0xffd9e2ed),
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

class _Clock extends State<Clock> with AutomaticKeepAliveClientMixin{
  Timer _timer;
  DateTime dateTime;
  static String time;
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
      time = dateTime.toString().substring(11,19);
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
            //clockText: widget.clockText,
            dateTime: dateTime,
          ),
          Container(
            padding: EdgeInsets.all(25),
            width: double.infinity,
            child: new CustomPaint(
              painter: new ClockDialPainter(),
            ),
          ),
          new ClockHands(dateTime: dateTime),
        ],

      ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class NumClock extends StatefulWidget {//数字时钟


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

class _NumClock extends State<NumClock> with AutomaticKeepAliveClientMixin{

  Timer _timer;
  DateTime dateTime;
  static String time;//时间
  static String day;//日期
  @override
  void initState() {
    super.initState();
    //getTimeZone();
    dateTime = new DateTime.now();
    this._timer = new Timer.periodic(widget.updateDuration, setTime);

    time = dateTime.toString().substring(11,19);
    day = dateTime.toString().substring(0,10);
  }
  void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
      time = dateTime.toString().substring(11,19);
      day = dateTime.toString().substring(0,10);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "日期",
                  style: TextStyle(
                      color: Color(0xffff0863),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "$day",
                  style: TextStyle(
                      color: Color(0xff2d386b),
                      fontSize: 30,
                      fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "当前时间",
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}