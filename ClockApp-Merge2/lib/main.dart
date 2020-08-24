import 'package:flutter/material.dart';
import 'screens/first_screen.dart';
import 'screens/second_screen.dart';
import 'screens/third_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clock',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new AppClock(),
    );
  }
}

class AppClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        //height: 100,
        width: double.infinity,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              body: TabBarView(
                children: <Widget>[
                  FirstTab(),
                  SecondTab(),
                  ThirdTab(),
                ],
              ),
              bottomNavigationBar: Material(
                  color: Colors.white,
                  child: TabBar(
                      indicator: const BoxDecoration(),
                      indicatorWeight: 15,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Color(0xffff0863), //ICON和文字的颜色
                      labelStyle:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                      unselectedLabelColor: Colors.black26,
                      tabs: [
                        Tab(
                          text: "时钟",
                          icon: Icon(Icons.access_time, size: 34),
                        ),
                        Tab(
                          text: "闹钟",
                          icon: Icon(Icons.alarm, size: 34),
                        ),
                        Tab(
                          text: "计时器",
                          icon: Icon(Icons.timer, size: 34),
                        ),
                      ])),
            )));
  }
}
