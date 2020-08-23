/*
为了学习方便，我对每一个container都加了一个外边框，如果想去掉，76行，87行，96行，345行注释即可。
背景填充在78行
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//计算总时间
int time=20;

//现在显示的时间
int disph=0;
int dispm=0;
int disps=0;

//是否在滚动
bool roll=false;

//对第一个按钮状态的控制，false代表停止中，true代表运行中
bool _active=false;

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: BasicAppBarSample(),
//    );
//  }
//}

//主界面
class BasicAppBarSample extends StatefulWidget {
  @override
  _BasicAppBarSampleState createState() => new _BasicAppBarSampleState();
}

class _BasicAppBarSampleState extends State<BasicAppBarSample> {

  //用来检查是否滚动过
  Timer timer;
  static const duration = const Duration(seconds: 1);

  //滚动之后应该怎么办
  void wan() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context, width: 1080, height: 2070, allowFontScaling:false );

    if(timer == null){
      timer = Timer.periodic(duration , (Timer t) {
        if(disph==0&&dispm==0&&disps==0) {
          roll=true;
        }
        if(_active==true) {
          time--;
          if(time==0)roll=true;
        }
        if(roll==true) {
          _active=false;
          wan();
        };
      });

    }

    return  Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        // elevation: 0,///设置AppBar透明，必须设置为0
        title: Text('Timer',style: TextStyle(color: Colors.white,fontSize:ScreenUtil().setSp(55)),),
        backgroundColor: Color.fromRGBO(88, 147, 195, 1.0),
        leading:new Icon(Icons.access_alarm),
      ),
      body: new Container(
          height: ScreenUtil().setHeight(1900),
          width: ScreenUtil().setWidth(1080),
          margin:   EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(0), ScreenUtil().setWidth(0), ScreenUtil().setHeight(0)),
          padding:  EdgeInsets.all(ScreenUtil().setWidth(16)),
          decoration: new BoxDecoration(
            //border: new Border.all(color: Colors.red),
            image: DecorationImage(
              image: AssetImage("assets/image/plane.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child:new Column(
            children: <Widget>[
              Container(
                margin:   EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(25), ScreenUtil().setWidth(0), ScreenUtil().setHeight(20)),
                decoration: new BoxDecoration(
                  //border: new Border.all(color: Colors.red),
                ),
                height: ScreenUtil().setHeight(1450),
                width: ScreenUtil().setWidth(1080),
                child: TimerApp(),
              ),
              Container(
                margin:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(20), ScreenUtil().setWidth(0), ScreenUtil().setHeight(0)),
                decoration: new BoxDecoration(
                  //border: new Border.all(color: Colors.red),
                ),
                height: ScreenUtil().setHeight(300),
                width: ScreenUtil().setWidth(1080),
                child: RollingSwitch(),
              ),
            ],
          )
      ),
    );
  }
}

//
//void main() {
//
//  runApp(new MyApp());
//}


//下面的滚动小球
class RollingSwitch extends StatefulWidget {
  RollingSwitch({Key key, this.active1: false, this.active2: false,})
      : super(key: key);
  final bool active1;
  final bool active2;
  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<RollingSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  var value = 0.0;
  String offText = "end";
  String onText = "begin";
  IconData onIcon = Icons.flag;
  IconData offIcon = Icons.check;
  bool isOn = false;
  static const duration = const Duration(seconds: 1);
  Timer timer;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(seconds: 0));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if(timer == null){
      timer = Timer.periodic(duration, (Timer t){
        if(_active==false) {
          time=disps+dispm*60+disph*3600;
          animationController.reset();
          if(time>0) {
            animationController.duration = Duration(seconds: time);
          }
          animationController.stop();
        }
        else {
          animationController.forward();
        }
      }
      );
    }
    return  Container(
      padding: EdgeInsets.only(left:ScreenUtil().setWidth(15),top:ScreenUtil().setHeight(60)),
      width: ScreenUtil().setWidth(450),
      decoration: BoxDecoration(
        //  color:  Colors.lime,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(50))),
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(10 * (1 - value), 0),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Container(
                padding: EdgeInsets.only(left:5.0,top:15.0),
                child: Text(
                  onText,
                  style: TextStyle(
                      color: Color.fromRGBO(95, 95, 95, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(10 * value, 0),
            child: Opacity(
              opacity: (1 - value).clamp(0.0, 1.0),
              child: Container(
                padding: EdgeInsets.only(right: 15,top:15),
                alignment: Alignment.centerRight,
                height: 40,
                child: Text(
                  offText,
                  style: TextStyle(
                      color: Color.fromRGBO(95, 95, 95, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(300*value, 0),
            child: Transform.rotate(
              angle: lerpDouble(0, 2*pi, value),
              child: Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/image/plane.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      //child: Icon(offIcon,color: Colors.red,),
                    ),
                    Opacity(
                      opacity: (1 - value).clamp(0.0, 1.0),
                      //child: Icon(onIcon,color: Colors.greenAccent,),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}



//中间的时钟
class TimerApp extends StatefulWidget {
  TimerApp({Key key,})
      : super(key: key);
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {

  void press(){
    if(_active==true)roll=true;
    else roll=false;
    setState(() {
      _active=!_active;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      margin:  const EdgeInsets.fromLTRB(0, 125, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CustomTextContainer(
                label: 'HRS',//padLeft 补占位符
              ),
              new CustomTextContainer(
                label: 'MIN',
              ),
              new CustomTextContainer(
                label: 'SEC',
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 100),
            height: 100,
            width: 100,

            child: RaisedButton(
              shape: CircleBorder(
                side: BorderSide(),
              ),
              color:Colors.orange,

              child: Text(_active ? 'STOP' : 'START'),
              onPressed: press,
            ),
          ),
        ],
      ),
    );
  }
}



//文本框
class CustomTextContainer extends StatelessWidget {
  CustomTextContainer({Key key, this.label})
      : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black87,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container (
            height: 50,
            width: 80,
            margin:  const EdgeInsets.fromLTRB(0,10,0,20),
            decoration: new BoxDecoration(
              // border: new Border.all(color: Colors.red),
            ),
            child :new ScrollControllerTestRoute(
              label:label,
            ),
          ),
          Text(
            "$label",
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }

}




//滚动的列表
class ScrollControllerTestRoute extends StatefulWidget {

  ScrollControllerTestRoute({Key key,this.label})
      : super(key: key);
  final String label;
  @override
  ScrollControllerTestRouteState createState() {
    return new ScrollControllerTestRouteState();
  }
}

class ScrollControllerTestRouteState extends State<ScrollControllerTestRoute> {


  ScrollController _controller = new ScrollController(initialScrollOffset: 10.0);

  Timer timer;
  Timer timer2;
  static const duration=Duration(seconds: 1);
  int count=0;
  int x=0;
  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {

      print(_controller.offset); //打印滚动位置


      if(_controller.offset%50==10){
        int x=(_controller.offset/50).toInt();
        if(widget.label=='HRS') {
          disph=x;
        }
        else if(widget.label=='MIN') {
          dispm=x;
        }
        else {
          disps=x;
        }
      }


    }
    );
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(timer == null){
      timer = Timer.periodic(duration, (Timer t){
        if(_controller.offset%50!=10&&roll==true) {
          if(_controller.offset>2960)
          {
            if(_active==false) {
              _controller.animateTo(2960,
                  duration: Duration(microseconds: 200),
                  curve: Curves.linear
              );
            }
          }
          else if(_controller.offset%50<35)
          {
            _controller.animateTo(_controller.offset-_controller.offset%50+10,
                duration:Duration(microseconds: 200),
                curve: Curves.linear
            );
          }
          else
          {
            _controller.animateTo(_controller.offset-_controller.offset%50+60,
                duration:Duration(microseconds: 200),
                curve: Curves.linear
            );
          }
        }

        if(_active==true) {
          if (widget.label == 'HRS') {
            if (disph > 0&&count==0)
              _controller.animateTo(10.0,
                  duration: Duration(hours: disph),
                  curve: Curves.linear
              );
          }
          else if (widget.label == 'MIN') {
            if (dispm > 0&&count==0) {
              _controller.animateTo(10.0,
                  duration: Duration(minutes: dispm),
                  curve: Curves.linear
              );
              x=0;
            }
            else if(disph>0&&dispm==0&&x==0) {
              _controller.jumpTo(3000,
              );
              _controller.animateTo(2960,
                  duration: Duration(seconds: 60),
                  curve: Curves.linear
              );
              count=-60;x=1;
            }
          }

          else if (widget.label == 'SEC') {
            if (disps > 0&&count==0) {
              _controller.animateTo(10.0,
                  duration: Duration(seconds: disps),
                  curve: Curves.linear
              );
            }
            else if ((disph > 0 || dispm > 0)&&disps==0) {

              _controller.jumpTo(3000,
              );
              _controller.animateTo(2960,
                  duration: Duration(microseconds: 800),
                  curve: Curves.linear
              );
              count=-1;
            }
          }
          count++;
        }
        if(_active==false) {
          count=0;
        }
      });
    }




    return GestureDetector(
      child: new ListView.builder(padding: new EdgeInsets.all(5.0),
        itemCount: 60,
        itemExtent: 50.0,
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          String s = index.toString().padLeft(2, '0');
          return new Text(
            s,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold
            ),
          );
        },
      ),
      onTap:() => roll=true,
    );
  }
}
