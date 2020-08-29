import 'dart:async';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zhushanApp/components/QRcodeHelper.dart';
import 'package:zhushanApp/helps/GlobleValue.dart';
import 'package:flutter/material.dart';
import 'package:zhushanApp/helps/SQLiteHelp.dart';
import 'MemberPage.dart';
import 'helps/globlefun.dart';
import 'helps/helps.dart';
import 'HomePage.dart';
import 'TypePage.dart';
import 'package:synchronized/synchronized.dart';


void main() {
  runApp(MyApp());
}
final routes = <String, WidgetBuilder>{};
class MyApp extends StatelessWidget {
  final GlobalKey _widgetKey = GlobalKey();
  @override
  void initState(){
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTile,
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      // 去除右上方Debug標誌
      home: ViewTemplate(key:_widgetKey),
      routes: routes,
    );
  }
}
class ViewTemplate extends StatefulWidget {
  ViewTemplate({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ViewTemplateStates();
}
class ViewTemplateStates extends State<ViewTemplate>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _prevselectedIndex = 0;
  double padValue=0;
  Lock lock;
  QRcodeHelper _qRcodeHelper;
  Widget loadinPage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _widgetKey = GlobalKey();
  static GlobalKey HomePage_widgetKey = GlobalKey();
  static GlobalKey TypePage_widgetKey = GlobalKey();
  static HomePage _homePage;
  static TypePage _typePage;
  static List<Widget> _widgetOptions ;
    //HomePage(),
  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        _qRcodeHelper.QRCodePostResult();
      } else {
        _prevselectedIndex = _selectedIndex;
        _selectedIndex = index;
      }
    });
  }
  bool isGetting;
  bool isAnimate;
  bool isAnimateButton;
  Timer timer;
  AnimationController controller;
  Animation<Offset> Offsetanimation;
  @override
  void initState() {
    _qRcodeHelper = new QRcodeHelper(context);
    lock = new Lock();
    _prevselectedIndex = 0;
    padValue=0;
    isAnimate = false;
    isAnimateButton=false;
    if(GlobleValue.deviceId!=null)
      isGetting=false;
    else
      isGetting=true;
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _homePage=HomePage(key: HomePage_widgetKey);
    _typePage=TypePage(key: TypePage_widgetKey);
    _widgetOptions = <Widget>[
      _homePage,
      _typePage,
      Container(),
      MemberPage()
      //HomePage(),
    ];

  }

  void BulidLoadingPage() {
    final Tween PosTween =
        new Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0.4));
    Offsetanimation = PosTween.animate(controller);
    final Widget showText =Container(
        decoration:BoxDecoration (color:Color.fromARGB(255, 250,250,250) , border: Border(bottom: BorderSide(width: 0.5,color: Colors.black54))),
        child:Padding(
        padding: EdgeInsets.all(20),
            child:RichText(
              text: TextSpan(
                text: "無法連線上伺服器，請確認網路或稍後再嘗試。您可以顯示裝置QRcode，由工作人員進行相關作業。",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            )));
    final Widget showButton = Container(
        padding: EdgeInsets.only(bottom: 100),child:RaisedButton(
        color: ButtonColorNormal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          ShowQRcodeImage(
              context,
              QrImage(
                data: encydata(GlobleValue.proxycode, GlobleValue.deviceId),
                version: QrVersions.auto,
                size: 200,
                gapless: false,
              ));
        },
        child: Text("顯示裝置QRcode", style: TextStyle(color: Colors.white))));
    loadinPage = Container(
        decoration: new BoxDecoration(color: Colors.white),
            child: Stack(
              alignment: AlignmentDirectional.topStart,
          children: <Widget>[
             Center(child:  SizedBox(width: 50, height: 50, child:CircularProgressIndicator())),
            Opacity(
            opacity: isAnimate ? 1.0 : 0.0,
            child:
          SlideTransition(
              key: _widgetKey,
              position: Offsetanimation,
              child: showText,
            )),
            Align(
                alignment: Alignment.bottomCenter,
                child:AnimatedOpacity(
                opacity:isAnimateButton?1.0:0.0,
                duration: Duration(milliseconds: 1000),
                child:showButton))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (isGetting && !isAnimate) {
      timer=Timer(Duration(seconds: 10), () {
        if (isGetting && GlobleValue.deviceId != null) {
          setState(() {
            isAnimate = true;
            controller.forward();
            Timer(Duration(seconds: 2), () {
              setState(() {
                if(isGetting)
                isAnimateButton=true;
                padValue=120;
              });
            });
          });
        }
      });
    }
    if (GlobleValue.deviceId == null) {
      isGetting=true;
      _getId(context);
    }
    if(isGetting)BulidLoadingPage();
    return InitDevice(context);
  }
  Widget InitDevice(BuildContext context) {
   Widget  screen = isGetting
        ? loadinPage
        : Scaffold(
            key: _scaffoldKey,
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                var tween;
                if (_prevselectedIndex > _selectedIndex)
                  tween =
                      Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0));
                else
                  tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
                return MySlideTransition(
                  child: child,
                  position: tween.animate(animation),
                );
              },
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
    return screen;
  }
  Future<void> _getId(BuildContext context) async {
    Object data = await getId(context,false);
    setState(() {
      isGetting = false;
      if (data is String) {
        if(timer!=null&&timer.isActive)
        timer.cancel();
        GlobleValue.message_publish=data+"\n"+GlobleValue.message_publish;
      }
    });
  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    controller.dispose();
    timer.cancel();
    super.dispose();
  }
}
