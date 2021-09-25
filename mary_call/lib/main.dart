//@dart=2.9
import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'addTimer.dart';
import 'variant.dart';
import 'map.dart';
import 'base.dart';

void main() {
  runApp(MaterialApp(home: BasePage())); // ここが Widget ツリーの起点
}

class TimerPage extends StatefulWidget {
  // 状態を持ちたいので StatefulWidget を継承
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer _timer; // この辺が状態
  DateTime _time;
  DateTime set_time;
  String _location = "no data";
  Future<void> getLocation() async {
    // 現在の位置を返す
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // 北緯がプラス。南緯がマイナス
    print("緯度: " + position.latitude.toString());
    // 東経がプラス、西経がマイナス
    print("経度: " + position.longitude.toString());
    // 高度
    print("高度: " + position.altitude.toString());
    // 距離をメートルで返す
    double distanceInMeters =
        Geolocator.distanceBetween(35.68, 139.76, -23.61, -46.40);
    print(distanceInMeters);
    // 方位を返す
    double bearing = Geolocator.bearingBetween(35.68, 139.76, -23.61, -46.40);
    print(bearing);
    setState(() {
      _location = position.toString();
    });
  }

  //DateTime.parse(2019-04-30 10:48:27.701406)
  //2019-04-30 10:48:27.7014
  void _onTimer(Timer timer) {
    // print("counting");
    var now = DateTime.now();
    now = now.add(Duration(hours: 9));
    // print(now.toIso8601String());
    if (set_times != null) {
      set_time = set_times[0];
      // print(set_time.toIso8601String());
      var diff = set_time.difference(now).inSeconds.abs();
      // print(diff);
      if (diff < 1) {
        FlutterRingtonePlayer.playAlarm();
        set_times.removeAt(0);
        print("start");
        getLocation();
      }
    } else {}
  }

  @override
  void initState() {
    // 初期化処理
    // set_times.add(DateTime.parse("2021-09-25 14:40:30.701406"));

    _time = DateTime.utc(0, 0, 0);
    // Timer.periodic(const Duration(seconds: 1), _onTimer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // setState() の度に実行される
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: "hero1",
              onPressed: () {
                FlutterRingtonePlayer.stop();
                print("stop");
                // Stopボタンタップ時の処理
              },
              child: Text("Stop"),
            ),
            FloatingActionButton(
              heroTag: "hero2",
              onPressed: () {
                print("get location");
                // Stopボタンタップ時の処理
                getLocation();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapPage()));
              },
              child: Text("get location"),
            ),
          ],
        )
      ]),
      floatingActionButton: FloatingActionButton(
          heroTag: "hero3",
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTimer()));
          }),
    );
  }
}
