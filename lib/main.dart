import 'package:flutter/material.dart';
import 'MemberPage.dart';
import 'QrcodeScan.dart';
import 'helps/helps.dart';
import 'HomePage.dart';
import 'TypePage.dart';

void main() {
  runApp(MyApp());
}
final routes = <String, WidgetBuilder>{
};
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTile,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      // 去除右上方Debug標誌
      home: ViewTemplate(),
      routes: routes,
    );
  }
}
class ViewTemplate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ViewTemplateStates();
}
class ViewTemplateStates extends State<ViewTemplate> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TypePage(),
    QrcodeScan(),
    MemberPage()
    //HomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
}
