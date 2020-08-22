import 'package:clock_app/clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/alarm/alarm.dart';
import 'dart:async';

class SecondTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Alarm(title: '闹钟'),
    );


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("闹钟"),
          backgroundColor: Color.fromARGB(255, 119, 136, 213), //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: Center(
            child: ListView(children: <Widget>[
              SizedBox(
                //用于前面空行
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Clock(),
              ),
              SizedBox(
                //后面与文字之间的空行
                height: 55,
              ),
              NumClock()
            ])),
      ),
    );
  }
}
