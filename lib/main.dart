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
  int _prevselectedIndex = 0;
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
        _prevselectedIndex=_selectedIndex;
        _selectedIndex = index;
      }
    });
  }
  bool isGetting = false;

  @override
  void initState() {
    _qRcodeHelper=new QRcodeHelper(context);
    lock = new Lock();
    _prevselectedIndex=0;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (!isGetting && GlobleValue.deviceId == null) {
      isGetting = true;
      _getId(context);
    }
    return InitDevice();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget InitDevice() {
    /*if (GlobleValue.deviceId == null) {
      return
        Scaffold(
            key: _scaffoldKey,
            body:
        Center(
          child: CircularProgressIndicator()));
    } else*/
      return Scaffold(
        key: _scaffoldKey,
        body:
        AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
            transitionBuilder:(Widget child, Animation<double> animation) {
              var tween;
            if(_prevselectedIndex>_selectedIndex)
               tween=Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0));
            else
              tween=Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
              return MySlideTransition(
                child: child,
                position: tween.animate(animation),
              );
            },
            child:_widgetOptions.elementAt(_selectedIndex),
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
  Future<void> _getId(BuildContext context) async {
      Object data= await getId(context);
      setState(() {
        if(data is String) {
          final snackBar = SnackBar(
              content: Text(data));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      });
  }
}
