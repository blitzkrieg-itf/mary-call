//@dart = 2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_application_1/today.dart';
import 'map.dart';
import 'addTimer.dart';
import 'variant.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Base';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: BasePage(),
    );
  }
}

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // 表示中の Widget を取り出すための index としての int 型の mutable な stored property
  int _selectedIndex = 0;
  String res_ = '';
  DateTime _time;
  DateTime set_time;

  // 表示する Widget の一覧
  static List<Widget> _pageList = [
    AddTimer(),
    MapPage(),
  ];
  @override
  void initState() {
    // 初期化処理
    // set_times.add(DateTime.parse("2021-09-25 14:40:30.701406"));

    _time = DateTime.utc(0, 0, 0);
    Timer.periodic(const Duration(seconds: 1), _onTimer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('AddTimer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Map'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTimer(Timer timer) {
    print("counting");
    var now = DateTime.now();
    now = now.add(Duration(hours: 9));
    // print(now.toIso8601String());
    if (set_times != null) {
      set_time = set_times[0];
      print(set_time.toIso8601String());
      var diff = set_time.difference(now).inSeconds.abs();
      print(diff);
      if (diff < 1) {
        FlutterRingtonePlayer.playAlarm();
        set_times.removeAt(0);
        print("start");
        _onItemTapped(1);
      }
    }
  }
}
