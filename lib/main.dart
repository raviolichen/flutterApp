import 'package:demoApp/helps/GlobleValue.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'DataService.dart';
import 'DetailPage.dart';
import 'MemberPage.dart';
import 'helps/helps.dart';
import 'HomePage.dart';
import 'TypePage.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:synchronized/synchronized.dart';

import 'modules/Record.dart';

void main() {
  runApp(MyApp());
}

final routes = <String, WidgetBuilder>{};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTile,
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      // 去除右上方Debug標誌
      home: ViewTemplate(key: UniqueKey()),
      routes: routes,
    );
  }
}

class ViewTemplate extends StatefulWidget {
  ViewTemplate({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewTemplateStates();
}

class ViewTemplateStates extends State<ViewTemplate> {
  int _selectedIndex = 0;
  Lock lock;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TypePage(),
    Container(),
    MemberPage()
    //HomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        QRCodePostResult();
      } else
        _selectedIndex = index;
    });
  }

  bool isGetting = false;

  @override
  void initState() {
    lock = new Lock();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (!isGetting && GlobleValue.deviceId == null) {
      isGetting = true;
      _getId();
    }
    return InitDevice();
  }

  Widget InitDevice() {
    if (GlobleValue.deviceId == null) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('首頁'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              title: Text('商家'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              title: Text('QR code'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessible_forward),
              title: Text('會員'),
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: BottomNavigationBarColor,
          selectedItemColor: BottomNavigationBarSelectColor,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      );
  }

  Future<void> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      GlobleValue.deviceId =
          iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      GlobleValue.deviceId =
          androidDeviceInfo.androidId; // unique ID on Android
    }
    Map<String, dynamic> data =
        await UserService().getUserId(GlobleValue.deviceId);

    if(data["result"].toString().compareTo("true")==0) {
      GlobleValue.userId = int.parse(data["userId"]);
      GlobleValue.token = data["token"];
      GlobleValue.userName = data["userName"];
      GlobleValue.Golds = data["Golds"];
    }
      setState(() {});

  }

  ScanResult scanResult;
  final _flashOnController = TextEditingController(text: "開啟閃光燈");
  final _flashOffController = TextEditingController(text: "關閉閃光燈");
  final _cancelController = TextEditingController(text: "取消");
  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  Future<ScanResult> scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );
      return await BarcodeScanner.scan(options: options);
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        result.rawContent = '無法取得相機權限';
      } else {
        result.rawContent = '不明錯誤: $e';
      }
      return result;
    }
  }

  // ignore: non_constant_identifier_names
  void QRCodePostResult() async {
    ScanResult scanResult = await scan();
    if (scanResult.type == ResultType.Barcode) {
      Map<String, dynamic>  data = await QRcodeService().postQrcodeValue(
          GlobleValue.userId, GlobleValue.token, scanResult.rawContent);
      if (data!=null) {
        String message=data["result"];
        String slvsId=data["slvId"];
        bool isGuid=data["isGuid"]!=null&&data["isGuid"].toString().compareTo("true")==0;
        _showMyDialog(message,slvsId!=null&&isGuid,slvsId);

      }
    }
  }
  Future<void> _showMyDialog(String text,bool isShowAction,String slvId ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if(isShowAction)
          return AlertDialog(
            title: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('確認前往解說'),
                onPressed: () {
                  Record record=new Record(id:slvId,photo: "",title: "獲得的銀幣解說",data: "",url: "",subtext: "");
                  Navigator.pop(context);
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          new DetailPage(record: record)));
                },
              ),
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Record record=new Record(id:slvId,photo: "",title: "獲得的銀幣解說",data: "",url: "",subtext: "");
                  Navigator.pop(context);
                },
              ),
            ],
          );
        else
          return AlertDialog(
            title: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('確定'),
                onPressed: () {
                  //Record record=new Record(id:slvId,photo: "",title: "獲得的銀幣解說",data: "",url: "",subtext: "");
                  Navigator.pop(context);
                },
              ),
            ],
          );
      },
    );
  }
}
