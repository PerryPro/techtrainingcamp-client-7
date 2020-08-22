import 'package:clock_app/clock/clock.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FirstTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("时钟"),
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

    return ListView(
      children: <Widget>[
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
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "当前时间",
//                    style: TextStyle(
//                      color: Color(0xffff0863),
//                      fontSize: 15,
//                      fontWeight: FontWeight.w700,
//                      letterSpacing: 1.3
//                    ),
//                  ),
//                  SizedBox(height: 10,),
//                  Text(
//                    "",
//                    style: TextStyle(
//                      color: Color(0xff2d386b),
//                      fontSize: 30,
//                      fontWeight: FontWeight.w700
//                    ),
//                  )
//                ],
//              ),
//
//
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "WAKE UP IN",
//                    style: TextStyle(
//                      color: Color(0xffff0863),
//                      fontSize: 15,
//                      fontWeight: FontWeight.w700,
//                      letterSpacing: 1.3
//                    ),
//                  ),
//                  SizedBox(height: 10,),
//                  Text(
//                    "08:00 AM",
//                    style: TextStyle(
//                      color: Color(0xff2d386b),
//                      fontSize: 30,
//                      fontWeight: FontWeight.w700
//                    ),
//                  )
//                ],
//              ),
//
//
//          ],
//        )
      ],
    );
  }
}
