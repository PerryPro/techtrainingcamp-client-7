import 'dart:math';

import 'clock_text.dart';
import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter {
  final clockText;

  final hourTickMarkLength = 18.0;
  final minuteTickMarkLength = 13.0;

  final hourTickMarkWidth = 5.0;
  final minuteTickMarkWidth = 3.5;
  final offset = 8;
  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  //final double tickLength = 8.0;
  //final double tickWidth = 3.0;

  final romanNumeralList = [
    'XII',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI'
  ];

  ClockDialPainter({this.clockText = ClockText.roman})
      : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'Times New Roman',
          fontSize: 15.0,
        ) {
    tickPaint.color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle = 2 * pi / 60;
    final radius = size.width / 2 ;
    canvas.save();

    //绘制表盘
    canvas.translate(radius, radius);
    for (var i = 0; i < 60; i++) {
      //小时刻度更长
      if((i%5) == 0){
        tickMarkLength = hourTickMarkLength;
        tickPaint.strokeWidth = hourTickMarkWidth;
        tickPaint.color = Colors.black12;

      }
      else{
        tickMarkLength = minuteTickMarkLength;
        tickPaint.strokeWidth = minuteTickMarkWidth;
        tickPaint.color = Colors.white;
      }
      canvas.drawLine(new Offset(0.0, -radius - offset),
          new Offset(0.0, -radius + tickMarkLength - offset), tickPaint);

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
