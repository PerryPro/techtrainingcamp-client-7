/*
为了学习方便，我对每一个container都加了一个外边框，如果想去掉，76行，87行，96行，345行注释即可。
背景填充在78行
*/
import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
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


//主界面
class BasicAppBarSample extends StatefulWidget {
  @override
  _BasicAppBarSampleState createState() => new _BasicAppBarSampleState();
}

class _BasicAppBarSampleState extends State<BasicAppBarSample> with AutomaticKeepAliveClientMixin{

  //用来检查是否滚动过
  Timer timer;
  static const duration = const Duration(seconds: 1);
  AudioPlayer audioPlayer = AudioPlayer();
  String mp3Uri;
  int x=-1;
  @override
  void initState() {
    _load();
  }

  Future<Null> _load() async {
    final ByteData data = await rootBundle.load('assets/ringtone/法老.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/法老.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3Uri = tempFile.uri.toString();
    print('finished loading, uri=$mp3Uri');
  }

  play() async {
    int result = await audioPlayer.play(mp3Uri, isLocal: true);
    if (result == 1) {
      // success
      print('play success');
    } else {
      print('play failed');
    }
  }
  @override
  void deactivate() async{
    print('结束');
    int result = await audioPlayer.release();
    if (result == 1) {
      print('release success');
    } else {
      print('release failed');
    }
    super.deactivate();
  }


   void tanchu()
   {
     showDialog<Null>(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context)
     {
       return new AlertDialog(
         title: new Text('窗口'),
         content: new SingleChildScrollView(
           child: new ListBody(
             children: <Widget>[
               new Text('定时结束'),
             ],
           ),
         ),
         actions: <Widget>[
           new FlatButton(
             child: new Text('确定'),
             onPressed: () {
               deactivate();
               Navigator.pop(context);
             },
           ),
         ],
       );
     },
     ).then((val) {
       print(val);
     });
   }
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
          if(x==0) {
            play();
            tanchu();
            x=1;
          }
        }
        else if(_active=true) {
          x=0;
        }
        if(roll==true) {
          _active=false;
          wan();
        };
        if(x>0) {
          x++;
          if(x==10)
          {
            deactivate();
            x=-1;
          }
        }

      });

    }

    return  Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        // elevation: 0,///设置AppBar透明，必须设置为0
        title: Text('计时器',style: TextStyle(color: Colors.white,fontSize:ScreenUtil().setSp(55)),),
        backgroundColor: Color.fromARGB(255, 119, 136, 213),
        leading:new Icon(Icons.timer),
      ),
      body: new Container(
          height: ScreenUtil().setHeight(1650),
          width: ScreenUtil().setWidth(1080),
          margin:   EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(0), ScreenUtil().setWidth(0), ScreenUtil().setHeight(0)),
          padding:  EdgeInsets.all(ScreenUtil().setWidth(16)),
//          decoration: new BoxDecoration(
//            //border: new Border.all(color: Colors.red),
//            image: DecorationImage(
//              image: AssetImage("assets/image/墨水.jpg"),
//              fit: BoxFit.cover,
//            ),
//          ),
          child:new Column(
            children: <Widget>[
              Container(
                margin:   EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(10), ScreenUtil().setWidth(0), ScreenUtil().setHeight(20)),
                decoration: new BoxDecoration(
                  //border: new Border.all(color: Colors.red),
                ),
                height: ScreenUtil().setHeight(1230),
                width: ScreenUtil().setWidth(1080),
                child: TimerApp(),
              ),
              Container(
                margin:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(20), ScreenUtil().setWidth(0), ScreenUtil().setHeight(0)),
                decoration: new BoxDecoration(
                  //border: new Border.all(color: Colors.red),
                ),
                height: ScreenUtil().setHeight(230),
                width: ScreenUtil().setWidth(1080),
                child: RollingSwitch(),
              ),
            ],
          )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{
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
                      color: Color.fromRGBO(95, 95, 95, 0.0),
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
                      color: Color.fromRGBO(95, 95, 95, 0.0),
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
                    image: AssetImage("assets/image/星星.png"),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}



//中间的时钟
class TimerApp extends StatefulWidget {
  TimerApp({Key key,})
      : super(key: key);
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> with AutomaticKeepAliveClientMixin{

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
      margin:  const EdgeInsets.fromLTRB(0, 35, 0, 0),
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
            height: 75,
            width: 100,

            child: RaisedButton(
              shape: CircleBorder(
                //side: ,
              ),
              color:Color.fromARGB(255, 119, 136, 213),

              child:
              _active ? Icon(Icons.pause,color: Colors.white,size: 40,) : Icon(Icons.play_arrow,color: Colors.white,size: 40,),


//              Text(
//                  _active ? '停止' : '开始',
//                  style: TextStyle(
//                    color: Colors.white,
//                fontSize: 25,
//                //fontWeight: FontWeight.w700
//                  )
//              ),
              onPressed: press,
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
        borderRadius: BorderRadius.circular(20),
        color: Colors.black87,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container (
            height: 50,
            width: 65,
            margin:  const EdgeInsets.fromLTRB(0,20,0,20),
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
              fontSize: 18
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

class ScrollControllerTestRouteState extends State<ScrollControllerTestRoute> with AutomaticKeepAliveClientMixin{


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

      //print(_controller.offset); //打印滚动位置


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
                fontSize: 35,
                fontWeight: FontWeight.bold
            ),
          );
        },
      ),
      onTap:() => roll=true,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}