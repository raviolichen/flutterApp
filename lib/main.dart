import 'package:zhushanApp/components/QRcodeHelper.dart';
import 'package:zhushanApp/helps/GlobleValue.dart';
import 'package:flutter/material.dart';
import 'MemberPage.dart';
import 'helps/globlefun.dart';
import 'helps/helps.dart';
import 'HomePage.dart';
import 'TypePage.dart';
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
  QRcodeHelper _qRcodeHelper;
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
        _qRcodeHelper.QRCodePostResult();
      } else {
        _selectedIndex = index;
      }
    });
  }
  bool isGetting = false;

  @override
  void initState() {
    _qRcodeHelper=new QRcodeHelper(context);
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
    if(await getId(context))
      setState(() {});
  }
}
