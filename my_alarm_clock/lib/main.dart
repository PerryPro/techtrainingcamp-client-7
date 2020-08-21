import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '闹钟'),
    );
  }
}
  //主页面
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//时钟类，用于记录时钟的信息
class clockunit {
  //是否工作
  bool onwork;
  //是否每天工作，主要是在显示重复频率的时候需要用
  bool everyday;
  //一周中工作的天数，如果每天都工作则全为false
  var dayslist = new List<bool>(7);
  //闹钟的时
  int hour;
  //闹钟的分
  int minute;
  //构造函数
  clockunit(Map<String, String> map) {
    var dlist = map["daylist"];
    for (var i = 0; i < 7; i++) {
      dayslist[i] = dlist[i] == '1' ? true : false;
    }
    onwork = map["onwork"] == "true" ? true : false;

    everyday = map["everyday"] == "true" ? true : false;

    hour = int.parse(map["hour"]);

    minute = int.parse(map["minute"]);
  }
  //返回小时的字符串表示，将一位数表示成两位数
  String getHourString() {
    return hour < 10 ? ("0" + hour.toString()) : hour.toString();
  }
  //返回分的字符串表示，将一位数表示成两位数
  String getMinuteString() {
    return minute < 10 ? ("0" + minute.toString()) : minute.toString();
  }

  void checkEveryday(){
    if((dayslist[0] && dayslist[1] && dayslist[2] && dayslist[3] && dayslist[4] && dayslist[5] && dayslist[6]) ||
        (!dayslist[0] && !dayslist[1] && !dayslist[2] && !dayslist[3] && !dayslist[4] && !dayslist[5] && !dayslist[6])){
      everyday=true;
    }else{
      everyday=false;
    }
  }

  List toText() {
    var textlist = new List<String>();
    textlist.add(onwork.toString());
    textlist.add(everyday.toString());
    textlist.add(hour.toString());
    textlist.add(minute.toString());
    String dlistString = "";
    for (var i = 0; i < 7; i++) {
      if (dayslist[i]) {
        dlistString = dlistString + "1";
      } else {
        dlistString = dlistString + "0";
      }
    }
    textlist.add(dlistString);
    return textlist;
  }
}
//用于返回闹钟重复频率的字符串表示
String _repeatTime(clockunit clockAdd){
  //文字列表
  List<String> days=[
    "周日、",
    "周一、",
    "周二、",
    "周三、",
    "周四、",
    "周五、",
    "周六、"
  ];
  //结果字符串初始化为空
  String resultString="";
  //每天工作的话直接返回"每天"
  if(clockAdd.everyday){
    return "每天";
  }
  //不是每天工作，则查询工作的日子，将字符串表示逐个添加到结果字符串中
  for(var i=0;i<7;i++){
    if(clockAdd.dayslist[i]){
      resultString=resultString+days[i];
    }
  }
  //去掉尾巴，返回
  return resultString.replaceFirst("、","",resultString.length-1);
}

//主页的State
class _MyHomePageState extends State<MyHomePage> {
  //保存时钟列表
  var clocklists = new List<clockunit>();
  //音频播放器，用于播放铃声
  AudioPlayer audioPlayer=new AudioPlayer();
  //MP3文件路径
  final mp3LocalPath="Ringtone/clockmusic.mp3";
  //计时器1,2  1用于获取整分，这样2可以每一分钟才回调一次，节约资源
  Timer _timer1;
  Timer _timer2;

  //获取文件路径
  Future<File> _getLoaclFile() async {
    //获取应用目录// 获取本地文档目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/ClockRecord.txt');
  }

  //读文件
  Future<void> _readFile() async {
    try {
      /*
       * 获取本地文件目录
       * 关键字await表示等待操作完成
       */
      File file = await _getLoaclFile();
      // 使用给定的编码将整个文件内容读取为字符串
      List<String> contents = await file.readAsLines();

      print(contents);

      //有时候读出来为null，不知道是不是搞错了，这样保险一点
      if (contents == null) {
        print("file is empty!");
        return;
      } else {

        int length = contents.length;
        print("the length is $length");
        //先把原有的清空
        clocklists.clear();
        //将读出的内容用于构造闹钟列表
        if (contents[0] == "") {
          //没有闹钟
          print("file is empty");
        } else {
          //有闹钟
          for (var i = 0; i < contents.length; i++) {
            //设置好闹钟的初始化参数
            var json = <String, String>{
              "onwork": contents[i++],
              "everyday": contents[i++],
              "hour": contents[i++],
              "minute": contents[i++],
              "daylist": contents[i]
            };
            //添加一个闹钟到闹钟列表中
            clocklists.add(new clockunit(json));
          }
        }
      }
    } on FileSystemException {
      // 发生异常时返回默认值
      print("error in reading file!");
    }
  }

  //写文件
  Future<void> _writeFile() async {
    try {
      /*
       * 获取本地文件目录
       * 关键字await表示等待操作完成
       */
      File file = await _getLoaclFile();

      IOSink ioSink = file.openWrite();

      List<String> towriteString = new List<String>();
      if (clocklists == null) {
        print("clocklists is null!");
        return;
      }
      if (clocklists.length == 0) {
        //无闹钟列表
        ioSink.writeln("");
      } else {
        //有闹钟列表
        for (var i = 0; i < clocklists.length; i++) {
          //把闹钟列表中的所有闹钟的String形式保存在towriteString中
          List<String> textlist = clocklists[i].toText();
          for (var j = 0; j < 5; j++) {
            towriteString.add(textlist[j]);
          }
        }
        //开始写入文件
        for (var i = 0; i < towriteString.length - 1; i++) {
          //前n-1个
          ioSink.writeln(towriteString[i]);
        }
        //最后一个
        ioSink.write(towriteString[towriteString.length - 1]);
      }

      await ioSink.close();
    } on FileSystemException {
      // 发生异常时返回默认值
      print("error in writing file!");
    }
  }

  //显示弹窗和播放音频，计时器需要用到
  void showAlter(){
    //查询每一个闹钟是否符合条件
    for(var i=0;i<clocklists.length;i++){
      if(clocklists[i].onwork && (clocklists[i].everyday || clocklists[i].dayslist[DateTime.now().weekday%7])
          && clocklists[i].hour==DateTime.now().hour && clocklists[i].minute==DateTime.now().minute)
      //必须闹钟是处于工作状态，每天都是重复的或者今天是重复的一天，小时数和分钟数和现在的时间对得上
      {
        //弹出窗口，播放铃声
        print("时间到！");
        //audioPlayer.play(mp3LocalPath,isLocal: true);
        //弹窗
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Clock Time'),
              content: Text(('Time is up')),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("取消"),
                  onPressed: () {
                    //audioPlayer.pause();
                    //audioPlayer.dispose();
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("确定"),
                  onPressed: () {
                    //audioPlayer.pause();
                    //audioPlayer.dispose();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
        //结束计数(有待考虑，或许不用结束！)
      }else{
        print("第$i个不符合条件！");
      }
    }
  }
  void startTimer2(){
    const period= const Duration(minutes: 1);
    print("我是startTimer2()，启动计时器2！");
    print("时间：");
    print(DateTime.now());

    //首先查询一次
    showAlter();

    _timer2=Timer.periodic(period, (timer){
      //之后每一分钟查询一次
      showAlter();
    });
  }

  //取消定时器2
  void cancelTimer2(){
    if (_timer2 != null) {
      _timer2.cancel();
      _timer2 = null;
    }
  }

  //打开计时器1
  void startTimer1(){
    //每秒查询一次，为计数器二矫正为整分调用
    const period= const Duration(seconds: 1);
    var myseconds=60;
    _timer1 = Timer.periodic(period, (timer) {
        myseconds--;
      print("mysecons is $myseconds");

      if (DateTime.now().second == 0) {
        //整分，打开第二个计时器
        startTimer2();
        print(DateTime.now());
        print("已启动计时器2！");
        //取消定时器1
        cancelTime1();
      }
    });
  }

  //取消第一个定时器
  void cancelTime1(){
    if (_timer1 != null) {
      _timer1.cancel();
      _timer1 = null;
    }
  }
  //退出的时候释放资源
  @override
  void dispose(){
    super.dispose();
    cancelTime1();
    cancelTimer2();
  }
  @override
  //初始化，读取文件获得闹钟列表，同时启动计时器1
  void initState() {
    //调用原initState
    super.initState();

    _readFile().then((value) {
      setState(() {
        print("初始化刷新状态！");
      });
    });
    startTimer1();
  }

  //进入删除闹钟页面的导引函数
  void _editClock() async {
    clocklists = await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new ClockEditPage(clocklists: clocklists);
        },
      ),
    );
    setState(() {
      print("删除闹钟后刷新状态！");
    });
    //传回数据后再次写入文件中。
    _writeFile();
  }

  //返回组件，页面主要内容
  @override
  Widget build(BuildContext context) {
    //最外面套一个WillPopScope，主要是监听手机自带返回键的动作，在推出的时候保存文件
    return new WillPopScope(
      child: new Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(widget.title),
          actions: <Widget>[
            new FlatButton(
              textColor: Colors.white,
              //根据是否有闹钟选择是否开放按钮动作和显示文字
              onPressed: clocklists.length != 0 ? _editClock : null,
              child: Text(clocklists.length != 0 ? "删除" : ""),
            ),
            new IconButton(
                icon: new Icon(Icons.add_alarm), onPressed: _clockSetting)
          ],
        ),
        body: Container(
          //闹钟列表
          child: _clocklistShow(),
        ),
        floatingActionButton: FloatingActionButton(
          //浮动按钮+，点击可以添加闹钟
          onPressed: _clockSetting,
          tooltip: 'Add Clock',
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      onWillPop: () async{
        print("主界面返回键点击了");
        _writeFile().then((value) {
          print("文件已保存！");
        });
        //最后直接返回true就好，会直接退出程序，而不需要Navigator.pop()了
        return true;
    },
    );
  }
  //显示闹钟列表
  Widget _clocklistShow() {
    //构建列表
    return new ListView.builder(
        padding: const EdgeInsets.all(0.0),
        //itemExtent: 60,
        itemCount: clocklists.length,
        itemBuilder: (context, clocki) {
          //返回一个ListTile
          return _builderClockListRow(clocki);
        });
  }
  //构建闹钟列表的每一个成员
  Widget _builderClockListRow(int clocki) {
    return new ListTile(
      //时间
        title: Text(
          clocklists[clocki].getHourString() +
              ":" +
              clocklists[clocki].getMinuteString(),
          style: TextStyle(fontSize: 35),
          textAlign: TextAlign.left,
        ),
        //重复频率
        subtitle:Text(
          _repeatTime(clocklists[clocki]),
          style: TextStyle(fontSize: 15),
        ),
       //尾部显示一个开关，决定是否工作
       trailing: Switch(
           value: clocklists[clocki].onwork,
           onChanged: (value) {
             //每次点击开关之后要更新状态
             setState(() {
               clocklists[clocki].onwork = !clocklists[clocki].onwork;
               print(
                   "the $clocki is " + clocklists[clocki].onwork.toString());
             });
           }),
    );
  }

  //进入添加闹钟的导引函数
  void _clockSetting() async {
    clocklists = await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new ClockSettingPage(clocklists: clocklists);
        },
      ),
    );
    setState(() {
      print("传回数据后刷新状态！");
    });
    //传回数据后再次写入文件中。
    _writeFile();
  }
}
  //添加闹钟的页面
class ClockSettingPage extends StatefulWidget {
  ClockSettingPage({Key key, this.clocklists}) : super(key: key);
  List clocklists;
  @override
  createState() => new ClockSettingPageState(clocklists: clocklists);
}
  //添加闹钟页面的State
class ClockSettingPageState extends State<ClockSettingPage> {
  //String 列表，用于填充，时间选择器中小时选择器的成员
  final List ListHourString = [
    "00",
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23"
  ];
  //String 列表，用于填充，时间选择器中分钟选择器的成员
  final List ListMinuteString = [
    "00",
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40",
    "41",
    "42",
    "43",
    "44",
    "45",
    "46",
    "47",
    "48",
    "49",
    "50",
    "51",
    "52",
    "53",
    "54",
    "55",
    "56",
    "57",
    "58",
    "59"
  ];

  ClockSettingPageState({Key key, this.clocklists});
  //时钟列表
  List clocklists;
 //时间选择器每一项的高度
  final int itemHeight = 60;
 //字风格
  final _itemFont = const TextStyle(fontSize: 40.0);


  //用于描述选择重复日期的时候，选择按钮的背景色，默认都没有选择，每天重复
  List repitionRateBgColor=[Colors.white,Colors.white,Colors.white,Colors.white,Colors.white,Colors.white,Colors.white];
  //监听器1，监听小时选择器
  var controller1 = new ScrollController();
 //监听器，监听分钟选择器
  var controller2 = new ScrollController();
  //初始状态的闹钟构造函数的参数
  var initjson = <String, String>{
    "onwork": "true",
    "everyday": "true",
    "hour": "00",
    "minute": "00",
    "daylist": "0000000"
  };
  //中间量，可能会被新添加的闹钟
  clockunit clockAdd;

  //初始化，对clockAdd初始化
  @override
  void initState() {
    super.initState();
    clockAdd = new clockunit(initjson);
    print("clockAdd has been init!");
  }
 //界面的主要内容
  @override
  Widget build(BuildContext context) {
    //最外层套一个WillPopScope主要是为了监听手机自带返回键的动作，在返回的时候，添加回传的数据，默认状态会返回null，导致错误
    return new WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('编辑闹钟'),
          centerTitle: true,
          automaticallyImplyLeading: false, //设置没有返回按钮
          //点击取消
          leading: new FlatButton(
              onPressed: _cancelToHome,
              child: new Text(
                "取消",
                textAlign: TextAlign.left,
              )),
          actions: <Widget>[
            //点击添加
            new FlatButton(onPressed: _finishToHome, child: new Text("完成")),
          ],
        ),
        body: Flex(//设置好时间选择器，重复频率显示，重复频率选择器的页面布局
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(flex: 1, child: Container()),
                    Expanded(flex: 4, child: _buildHourVeiw()),
                    Expanded(flex: 1, child: Container()),
                    Expanded(flex: 4, child: _buildMinuteVeiw()),
                    Expanded(flex: 1, child: Container()),
                  ],
                )),
            Expanded(flex: 1, child: _repetitionRateRow()),
            Expanded(flex: 2,child: _repetitionRateSelectRow(),)
          ],
        ),
      ),
        //手机自带返回键点击后，退出闹钟添加页，并且回传数据
        onWillPop: (){print("返回键点击了");Navigator.pop(context,clocklists);}
    );

  }
 //取消添加函数，退出本页，带回数据
  void _cancelToHome() {
    Navigator.pop(context, clocklists);
  }
 //完成添加，退出本页，带回数据
  void _finishToHome() {
    clocklists.add(clockAdd);
    Navigator.pop(context, clocklists);
  }
  //显示重复频率的组件
  Widget _repetitionRateRow(){
    return new ListTile(
      title: new Text("重复"),
      trailing: new Text(_repeatTime(clockAdd)),
    );
  }
  //重新频率选择器组件
  Widget _repetitionRateSelectRow(){
    return new Flex(direction: Axis.horizontal,
      children: [
      Expanded(flex: 1,child: Container(
        color:repitionRateBgColor[0],
            child: FlatButton(
              child: new Text("日"),
              onPressed:()=>_repetionRateChangeBkColor(0)
            ),
      ),),
        Expanded(flex: 1,child: Container(
          color:repitionRateBgColor[1],
          child: FlatButton(
              child: new Text("一"),
              onPressed:()=>_repetionRateChangeBkColor(1)
          ),
        ),),
        Expanded(flex: 1,child: Container(
          color:repitionRateBgColor[2],
          child: FlatButton(
              child: new Text("二"),
              onPressed:()=>_repetionRateChangeBkColor(2)
          ),
        ),),
        Expanded(flex: 1,child: Container(
          color:repitionRateBgColor[3],
          child: FlatButton(
              child: new Text("三"),
              onPressed:()=>_repetionRateChangeBkColor(3)
          ),
        ),),
        Expanded(flex: 1,child: Container(
          color:repitionRateBgColor[4],
          child: FlatButton(
              child: new Text("四"),
              onPressed:()=>_repetionRateChangeBkColor(4)
          ),
        ),),
        Expanded(flex: 1,child: Container(
          color:repitionRateBgColor[5],
          child: FlatButton(
              child: new Text("五"),
              onPressed:()=>_repetionRateChangeBkColor(5)
          ),
        ),),
        Expanded(flex: 1,child: Container(
          color:repitionRateBgColor[6],
          child: FlatButton(
              child: new Text("六"),
              onPressed:()=>_repetionRateChangeBkColor(6)
          ),
        ),)
    ],);
  }
 //设置频率选择器按钮背景色的组件
  void _repetionRateChangeBkColor(int index){
     //每次点击，将状态变成另一种状态
      clockAdd.dayslist[index]=!clockAdd.dayslist[index];
      //检查是否七个按钮都按下了，据此更改onwork属性和dayslist属性
      clockAdd.checkEveryday();
      if(clockAdd.everyday){
        for(var i=0;i<7;i++){
          repitionRateBgColor[i]=Colors.white;
          clockAdd.dayslist[i]=false;
        }
      }else{
        if(clockAdd.dayslist[index]){
          repitionRateBgColor[index]=Colors.cyanAccent;
        }else{
          repitionRateBgColor[index]=Colors.white;
        }
      }
      //刷新状态
      setState(() {
        print("第$index 个按钮按下！");
      });
  }
  //小时选择器
  Widget _buildHourVeiw() {
    //套一个Listener，监听onPointerUp动作，每当手离开选择器，便更改闹钟的hour属性，并跳转到离偏移量最近的一项中
    return new Listener(
      onPointerUp: (event) {
        print("point is up hour");
        //获得此时的小时数
        clockAdd.hour = ((controller1.offset / itemHeight).round() % 24).abs();
        print(clockAdd.hour);
        //跳转到距离偏移量最近的一项上
        controller1.jumpTo(
            ((controller1.offset / itemHeight)).round() * itemHeight * 1.0);
      },
      child: ListWheelScrollView.useDelegate(
        //显示选择器
        useMagnifier: true,
        magnification: 1.1,
        controller: this.controller1,
        itemExtent: itemHeight * 1.0,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return ListTile(
                title: new Center(
              child: new Text(
                ListHourString[index % 24],
                style: _itemFont,
              ),
            ));
          },
        ),
      ),
    );
  }

  Widget _buildMinuteVeiw() {
    //套一个Listener，监听onPointerUp动作，每当手离开选择器，便更改闹钟的hour属性，并跳转到离偏移量最近的一项中
    return new Listener(
      onPointerUp: (event) {
        print("point is up Minute");
        //获得此时的分钟数
        clockAdd.minute =
            ((controller2.offset / itemHeight).round() % 60).abs();
        print(clockAdd.minute);
        //跳转到距离偏移量最近的一项中
        controller2.jumpTo(
            ((controller2.offset / itemHeight)).round() * itemHeight * 1.0);
      },
      child: ListWheelScrollView.useDelegate(//显示选择器
        useMagnifier: true,
        magnification: 1.1,
        controller: this.controller2,
        itemExtent: itemHeight * 1.0,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return ListTile(
              title: new Center(
                child: new Text(
                  ListMinuteString[index % 60],
                  style: _itemFont,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//删除闹钟页面
class ClockEditPage extends StatefulWidget{
  ClockEditPage({Key key, this.clocklists}) : super(key: key);
  List clocklists;
  @override
  createState() => new ClockEditPageState(clocklists: clocklists);
}
//删除闹钟页面的State
class ClockEditPageState extends State<ClockEditPage>{
  ClockEditPageState({Key key, this.clocklists});
  //闹钟列表
  List clocklists;
  //显示每一项是否被选中
  List deletSelectList=new List<bool>();
  //为true表示按下去会全选，为false表示按下去为全不选
  var flagSelectAll;
 //是否有项目被选择，决定删除键是否有效
  bool _someItemsAreSelected(){
    for(var i=0;i<deletSelectList.length;i++){
      if(deletSelectList[i]){
        return true;
      }
    }
    return false;
  }
  //初始化
  @override
  void initState() {
    super.initState();
    //每一项初始都是没有选中
    for(var i=0;i<clocklists.length;i++){
      deletSelectList.add(false);
    }
    //flagSelectAll初始为true，表示此时按全选就会全部选中
    flagSelectAll=true;
    setState(() {
      print("删除闹钟界面初始化！");
    });
  }

  //删除闹钟界面的主要界面
  @override
  Widget build(BuildContext context) {
    //套一个WillPopScope，监听手机自带返回键，按下时，退出界面，回传数据
    return new WillPopScope(
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('删除闹钟'),
            centerTitle: true,
            automaticallyImplyLeading: false, //设置没有返回按钮
            leading: new FlatButton(
                onPressed: _selectAll,
                child: new Text(
                  "全选",
                  textAlign: TextAlign.left,
                )),
            actions: <Widget>[
              new FlatButton(onPressed: _cancelToHome, child: new Text("取消")),
            ],
          ),
            floatingActionButton: FloatingActionButton(
              onPressed: _someItemsAreSelected()?_deleteToHome:null,
              tooltip: 'deleteClock',
              child: Icon(Icons.delete),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body:_ShowAllClock()
        ),
        onWillPop: (){print("删除闹钟返回键点击了");Navigator.pop(context,clocklists);}
    );

  }
  //把闹钟列表显示出来，每一项可以被选中
  Widget _ShowAllClock(){
    return new ListView.builder(
        padding: const EdgeInsets.all(0.0),
        //itemExtent: 60,
        itemCount: clocklists.length,
        itemBuilder: (context, clocki) {
          return _builderClockListRow(clocki);
        });
  }
  //具体显示闹钟列表的项
 Widget _builderClockListRow(int clocki) {
    return new CheckboxListTile(value: deletSelectList[clocki],
        title: Text(
          clocklists[clocki].getHourString() +
              ":" +
              clocklists[clocki].getMinuteString(),
          style: TextStyle(fontSize: 35),
          textAlign: TextAlign.left,
        ),
        subtitle: Text(
          _repeatTime(clocklists[clocki]),
          style: TextStyle(fontSize: 15),
        ),
        //更新状态
        onChanged: (v) {
          setState(() {
            deletSelectList[clocki] = v;
          });
         }
    );

   }
  //选择全部函数
  void _selectAll(){
    //flagSelectAll用于记录每一次的变化，如果之前是选择全部，那么之后是全部不选
      for(var i=0;i<deletSelectList.length;i++){
        deletSelectList[i]=flagSelectAll;
      }
      flagSelectAll=!flagSelectAll;
      setState(() {
        print("选择了全部！");
      });
  }
  //取消删除，返回到主界面
  void _cancelToHome(){
    print("取消删除，从删除界面返回到主界面！");
     Navigator.pop(context,clocklists);
  }
  //删除所选择的项，并且退回到主界面
  void _deleteToHome(){
     print("开始删除，从删除界面返回到主界面！");
     for(var i=0,j=0;i<deletSelectList.length;i++,j++){
       if(deletSelectList[i]){
         clocklists.removeAt(j--);//j--是因为，删除某项之后，后面的项会前移
       }
     }
     int length=clocklists.length;
     print("删除之后还有$length个闹钟！");
     Navigator.pop(context,clocklists);
  }
}