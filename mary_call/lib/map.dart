import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<MapboxMapController> _controller = Completer();
  final Location _locationService = Location();
  // 地図スタイル用 Mapbox URL
  final String _style =
      'mapbox://styles/amixedcolor/cktzwpvg30j8d18ouqmidhu6j'; // 地図を日本語化したときなどに必要
  // Location で緯度経度が取れなかったときのデフォルト値
  final double _initialLat = 35.6895014;
  final double _initialLong = 139.6917337;
  // 現在位置
  LocationData? _yourLocation;
  // GPS 追従？
  bool _gpsTracking = false;

  Future? myFuture;
  Map<String, dynamic> response = {};
  List<dynamic> points = [];

  // 現在位置の監視状況
  StreamSubscription? _locationChangedListen;

  final LatLng latlng1 = LatLng(35.678556, 139.773778);
  @override
  void initState() {
    super.initState();
    // 現在位置の取得
    // _getLocation();
    // 現在位置の変化を監視
    // _locationChangedListen =
    //     _locationService.onLocationChanged.listen((LocationData result) async {
    //   setState(() {
    //     _yourLocation = result;
    //   });
    // });
    setState(() {
      _gpsTracking = true;
    });
    _addMark(latlng1);
    _parsePoints();
    myFuture = _getFutureValue();
  }

  void _parsePoints() async {
    _yourLocation = await _locationService.getLocation();
    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      setState(() {
        _yourLocation = result;
      });
    });
    response = await getResponse(_yourLocation!.latitude ?? _initialLat,
        _yourLocation!.longitude ?? _initialLong, "10");
    points = makePoints(response);
    print(points);
    var latlng2 = points.removeAt(0);
    print(latlng2);
    _addMark(LatLng(latlng2[1], latlng2[0]));
  }

  void _addMark(LatLng tapPoint) {
    print("addMark");
    // マーク（ピン）を立てる
    _controller.future.then((mapboxMap) {
      mapboxMap.addSymbol(SymbolOptions(
        geometry: tapPoint,
        textField: "Mary",
        textAnchor: "top",
        textColor: "#000",
        textHaloColor: "#FFF",
        textHaloWidth: 3,
        iconImage: "mapbox-marker-icon-blue",
        //iconImage: "marker-15",
        iconSize: 1,
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();

    // 監視を終了
    _locationChangedListen?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text("私今ここにいるの")),
      body: Column(children: [
        Expanded(
          child: _makeMapboxMap(),
        ),
        Container(
            height: 60,
            width: 240,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
                child: Text("除霊する"),
                onPressed: () {
                  FlutterRingtonePlayer.stop();
                })),
      ]),
      // floatingActionButton: _makeGpsIcon(),
    );
  }

  Widget _makeMapboxMap() {
    if (_yourLocation == null) {
      // 現在位置が取れるまではロード中画面を表示
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    // GPS 追従が ON かつ地図がロードされている→地図の中心を移動
    if (_gpsTracking) {
      _controller.future.then((mapboxMap) {
        mapboxMap.moveCamera(CameraUpdate.newLatLng(LatLng(
            _yourLocation!.latitude ?? _initialLat,
            _yourLocation!.longitude ?? _initialLong)));
      });
    }
    // Mapbox ウィジェットを返す
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());

          /*
            return MapboxMap(
                accessToken:
                    "sk.eyJ1IjoiYW1peGVkY29sb3IiLCJhIjoiY2t0enFqNmt1MXliMjJwcXQ5amhhOTl2NSJ9._57ZEf9QRS391RNcdtsiuQ",
                // 地図（スタイル）を指定（デフォルト地図の場合は省略可）
                styleString: _style,
                // 初期表示される位置情報を現在位置から設定
                initialCameraPosition: CameraPosition(
                  target: LatLng(_yourLocation!.latitude ?? _initialLat,
                      _yourLocation!.longitude ?? _initialLong),
                  zoom: 13.5,
                ),
                onMapCreated: (MapboxMapController controller) {
                  _controller.complete(controller);
                },
                compassEnabled: true,
                // 現在位置を表示する
                myLocationEnabled: true,
                // 地図をタップしたとき
                onMapClick: (Point<double> point, LatLng tapPoint) {
                  _controller.future.then((mapboxMap) {
                    mapboxMap.moveCamera(CameraUpdate.newLatLng(tapPoint));
                  });
                  setState(() {
                    _gpsTracking = false;
                  });
                  
                });
                */
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData && snapshot.data != null) {
          return MapboxMap(
            accessToken:
                "sk.eyJ1IjoiYW1peGVkY29sb3IiLCJhIjoiY2t0enFqNmt1MXliMjJwcXQ5amhhOTl2NSJ9._57ZEf9QRS391RNcdtsiuQ",
            // 地図（スタイル）を指定（デフォルト地図の場合は省略可）
            styleString: _style,
            // 初期表示される位置情報を現在位置から設定
            initialCameraPosition: CameraPosition(
              target: LatLng(_yourLocation!.latitude ?? _initialLat,
                  _yourLocation!.longitude ?? _initialLong),
              zoom: 13.5,
            ),
            onMapCreated: (MapboxMapController controller) {
              _controller.complete(controller);
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("私メリーさん"),
                    content: Text("今あなたの家の近くにいるの・・・"),
                  );
                },
              );
            },
            compassEnabled: true,
            // 現在位置を表示する
            myLocationEnabled: true,
            // 地図をタップしたとき
            onMapClick: (Point<double> point, LatLng tapPoint) {
              _controller.future.then((mapboxMap) {
                mapboxMap.moveCamera(CameraUpdate.newLatLng(tapPoint));
              });
              setState(() {
                _gpsTracking = false;
              });
            },
          );
        } else {
          return Text("invalid");
        }
      },
    );
  }

  Widget _makeGpsIcon() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
        _gpsToggle();
      },
      child: Icon(
        // GPS 追従の ON / OFF に合わせてアイコン表示する
        _gpsTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
      ),
    );
  }

  void _gpsToggle() {
    setState(() {
      _gpsTracking = !_gpsTracking;
    });
    // ここは iOS では不要
    if (_gpsTracking) {
      _controller.future.then((mapboxMap) {
        mapboxMap.moveCamera(CameraUpdate.newLatLng(LatLng(
            _yourLocation!.latitude ?? _initialLat,
            _yourLocation!.longitude ?? _initialLong)));
      });
    }
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }
}

Future<dynamic> getResponse(lat, lng, time) async {
  print(
      "--------------------------------------------------------------------------------------------------------------fetchStores----------------------------------------------------------------------------------------------------");

  var lngString = lng.toString();
  var latString = lat.toString();
  final url = 'https://api.mapbox.com/isochrone/v1/mapbox/walking/' +
      lngString +
      '%2C' +
      latString +
      '?contours_minutes=' +
      time +
      '&polygons=true&denoise=1&access_token=pk.eyJ1IjoiYW1peGVkY29sb3IiLCJhIjoiY2t0eWM2empuMDloejJ1bnptNXF3eW11YiJ9.FmKXCHZOWVUzVtg2t8UuWg';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    // print(response.statusCode);
    print("success");
    String responseUTF = utf8.decode(response.bodyBytes);
    print(responseUTF);
    var decodedJson = json.decode(responseUTF);
    // print(decodedJson);
    return decodedJson;
  } else {
    print("failed");
  }
}

List<dynamic> makePoints(response) {
  List<dynamic> ret = response["features"][0]["geometry"]["coordinates"][0];
  return ret;
}

Future<String> _getFutureValue() async {
  return Future.delayed(new Duration(seconds: 5), () {
    return "completed!!";
  });
}
