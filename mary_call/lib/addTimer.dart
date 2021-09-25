//@dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'variant.dart';
import 'main.dart';

class addTimer extends StatefulWidget {
  // 状態を持ちたいので StatefulWidget を継承
  @override
  _addTimerState createState() => _addTimerState();
}

class _addTimerState extends State<addTimer> {
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
            title: Text('リスト追加'),
          ),
          // *** 追加する部分 ***
          body: Container(
            // 余白を付ける
            padding: EdgeInsets.all(64),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(''),
                  Container(
                    child: FloatingActionButton.extended(
                      label: Text('期限を入力'),
                      onPressed: () {
                        _selectTime(context);
                      },
                      tooltip: 'Datetime',
                      icon: Icon(Icons.access_time),
                    ),
                  ),
                  Text(''),
                  Text(
                    // フォーマッターを使用して指定したフォーマットで日時を表示
                    // format()に渡すのはDate型の値で、String型で返される
                    formatter.format(_mytime),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    // 横幅いっぱいに広げる
                    width: double.infinity,
                    // リスト追加ボタン
                    child: ElevatedButton(
                      onPressed: () {
                        set_times.add(_mytime);
                        Navigator.of(context).pop();
                      },
                      child: Text('登録', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    // 横幅いっぱいに広げる
                    width: double.infinity,
                    // キャンセルボタン
                    child: TextButton(
                      // ボタンをクリックした時の処理
                      onPressed: () {
                        // "pop"で前の画面に戻る
                        Navigator.of(context).pop();
                      },
                      child: Text('キャンセル'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
