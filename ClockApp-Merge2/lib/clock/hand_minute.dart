import 'dart:math';

import 'package:flutter/material.dart';

class MinuteHandPainter extends CustomPainter {
  final Paint minuteHandPaint;
  int minutes;
  int seconds;

  MinuteHandPainter({this.minutes, this.seconds})
      : minuteHandPaint = new Paint() {
    minuteHandPaint.color = Color(0xffc5cbdd);
    minuteHandPaint.style = PaintingStyle.stroke;
    minuteHandPaint.strokeWidth = 8.0;
    minuteHandPaint.strokeCap = StrokeCap.round;

  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * ((this.minutes + (this.seconds / 60)) / 60));

    Path path = new Path();
    path.moveTo(0.0, -radius * 0.75);
    path.lineTo(0.0, radius * 0.1);

    //path.close();
    //minuteHandPaint.strokeCap = StrokeCap.round;
    canvas.drawPath(path, minuteHandPaint);
    canvas.drawShadow(path, Colors.black, 4.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(MinuteHandPainter oldDelegate) {
    return true;
  }
}
