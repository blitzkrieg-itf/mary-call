//@dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'variant.dart';
import 'main.dart';
import 'base.dart';

class AddTimer extends StatefulWidget {
  // 状態を持ちたいので StatefulWidget を継承
  @override
  _AddTimerState createState() => _AddTimerState();
}

class _AddTimerState extends State<AddTimer> {
  final _formKey = GlobalKey<FormState>();

  DateFormat formatter;
  @override
  void initState() {
    super.initState();
    // getData();
    // res = fetchApiResults();
    initializeDateFormatting('ja_JP', null);
    formatter = new DateFormat('HH:mm');
  }
  // extension TimeOfDayExtension on TimeOfDay {
  //   TimeOfDay addHour(int hour) {
  //     return this.replacing(hour: this.hour + hour, minute: this.minute);
  //   }
  // }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay t = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 9))),
    );
    if (t != null) {
      var dt = _toDateTime(t);
      setState(() {
        _mytime = dt;
      });
    }
  }

  _toDateTime(TimeOfDay t) {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  String _title;
  String _detail;
  String _tasktime;
  var _mytime = new DateTime.now();
  // var formatter = new DateFormat('MM/dd(E) HH:mm');

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          // *** 追加する部分 ***
          appBar: AppBar(
            title: Text('アラーム設定'),
          ),
          // *** 追加する部分 ***
          body: Container(
            // 余白を付ける
            padding: EdgeInsets.all(64),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("set time"),
                  Container(
                    child: Text(
                        // フォーマッターを使用して指定したフォーマットで日時を表示
                        // format()に渡すのはDate型の値で、String型で返される
                        formatter.format(_mytime),
                        style: TextStyle(fontSize: 80)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 100, top: 30),
                    child: FloatingActionButton.extended(
                      label: Text('起きる時間'),
                      onPressed: () {
                        _selectTime(context);
                      },
                      tooltip: 'Datetime',
                      icon: Icon(Icons.access_time),
                    ),
                  ),
                  Container(
                    // 横幅いっぱいに広げる
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 40),
                    // リスト追加ボタン
                    child: ElevatedButton(
                      onPressed: () {
                        set_times.add(_mytime);
                        // set_times.add(_mytime.add(Duration(days: 1)));
                        count = 0;
                        thisTimeMaries = 0;
                      },
                      child: Text('セット', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Container(width: double.infinity, child: Text("累計除霊数")),
                  Container(
                      child: Text(maries.toString(),
                          style: TextStyle(fontSize: 100))),
                ],
              ),
            ),
          ),
        ));
  }
}
