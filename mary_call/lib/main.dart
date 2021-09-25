//@dart=2.9
import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(home: TimerSamplePage())); // ここが Widget ツリーの起点
}

class TimerSamplePage extends StatefulWidget {
  // 状態を持ちたいので StatefulWidget を継承
  @override
  _TimerSamplePageState createState() => _TimerSamplePageState();
}

class _TimerSamplePageState extends State<TimerSamplePage> {
  Timer _timer; // この辺が状態
  DateTime _time;
  DateTime set_time;
  List<DateTime> set_times = [];

  //DateTime.parse(2019-04-30 10:48:27.701406)
  //2019-04-30 10:48:27.7014
  void _onTimer(Timer timer) {
    print("counting");
    var now = DateTime.now();
    now = now.add(Duration(hours: 9));
    print(now.toIso8601String());
    set_time = set_times[0];
    print(set_time.toIso8601String());
    var diff = set_time.difference(now).inSeconds.abs();
    print(diff);
    if (diff < 1) {
      FlutterRingtonePlayer.playAlarm();
      set_times.removeAt(0);
      print("start");
    }
  }

  @override
  void initState() {
    // 初期化処理
    set_times.add(DateTime.parse("2021-09-25 14:40:30.701406"));

    _time = DateTime.utc(0, 0, 0);
    Timer.periodic(const Duration(seconds: 1), _onTimer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // setState() の度に実行される
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        DateFormat.Hms().format(_time),
        style: Theme.of(context).textTheme.headline2,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              FlutterRingtonePlayer.stop();
              print("stop");
              // Stopボタンタップ時の処理
              if (_timer != null && _timer.isActive) _timer.cancel();
            },
            child: Text("Stop"),
          ),
          FloatingActionButton(
            onPressed: () {
              // Timer.periodic(const Duration(seconds: 1), _onTimer);
              FlutterRingtonePlayer.playAlarm();
              print("start");
              // Startボタンタップ時の処理
              // _timer = Timer.periodic(
              //   Duration(seconds: 1), // 1秒毎に定期実行
              //   (Timer timer) {
              //     setState(() {
              //       // 変更を画面に反映するため、setState()している
              //       _time = _time.add(Duration(seconds: 1));
              //     });
              //   },
              // );
            },
            child: Text("Start"),
          ),
        ],
      )
    ]));
  }
}
