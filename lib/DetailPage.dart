import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demoApp/banner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'modules/Record.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'DataService.dart';
import 'helps/helps.dart';
import 'modules/detailitem.dart';
import 'modules/RecordList.dart';

enum detailType { info, active, other }

class DetailPage extends StatelessWidget {
  final Record record;
  final nonEventDetailPageStateful = _DetailPageStateful();
  DetailPage({this.record});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text(record.title),
          backgroundColor: ButtonColorSubmit,
        ),
        body: Stack(children: <Widget>[
          Hero(
            tag: "avatar_" + record.id.toString(),
            child: ListView(children: <Widget>[
              c_Banner([record.photo]),
              nonEventDetailPageStateful,
              Container(
                height: 60,
              ),
            ]),
          ),
          Positioned(
              bottom: 16,
              right: 16,
              child: Row(
                children: <Widget>[
                  MyFAB(url: "https://wwww.google.com", icon: Icon(Icons.web)),
                  MyFAB(
                      url: "https://wwww.yahoo.com.tw",
                      icon: Icon(Icons.people)),
                  MyFAB(
                      url:
                          "https://www.google.com/maps/search/?api=1&query=%E7%AB%B9%E5%B1%B1%E9%8E%AE%E5%85%AC%E6%89%80",
                      icon: Icon(Icons.map))
                ],
              )),
        ]));
  }
}
class URLLauncher {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _DetailPageStateful extends StatefulWidget {
  @override
  _DetailPageStatefulState createState() => _DetailPageStatefulState();
}

class _DetailPageStatefulState extends State<_DetailPageStateful> {
  String kNavigationExamplePage;
  bool isLoad;
  WebViewController _listController;
  double _heights;
  WebView _webview;
  RecordList _records = new RecordList();

  @override
  void initState() {
    super.initState();
    isLoad = false;
    _heights = 1.0;
    new Future.delayed(
        const Duration(milliseconds: 250), () => _loaddetailjson());
  }

  Future<void> _createWebView() async {
    _webview = new WebView(
      javascriptMode: JavascriptMode.unrestricted,
      //避免被導出特定的網址。
      navigationDelegate: (NavigationRequest request) {
        return NavigationDecision.prevent;/*
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        else
          return NavigationDecision.navigate;*/
      },
      onPageFinished: (some) async {
        //await _listController.evaluateJavascript("document.getElementsByTagName(\"iframe\")[0].width=document.body.clientWidth");
        double height2 = double.parse(await _listController
            .evaluateJavascript("document.body.clientHeight;"));
        setState(() {
          _heights = (height2 + 50);
          isLoad = true;
        });
      },
      onWebViewCreated: (controller) async {
        _listController = controller;
        _loadhtml();
      },
      onPageStarted: (context) {},
    );
    setState(() {});
  }

  Future<void> _loadhtml() async {
    await _listController.loadUrl(
        Uri.dataFromString(kNavigationExamplePage, mimeType: 'text/html',  parameters: { 'charset': 'utf-8' })
            .toString());
  }

  DetailItem detailItem;
  Widget ActiveButton = Container();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        !isLoad
            ? Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : SizedBox(),
        Container(
          height: _heights ?? 0,
          child: _webview,
        ),
        ActiveButton
      ]),
    );
  }

  void _loaddetailjson() async {
    detailItem = await DetailService().loadDetail(5);
    kNavigationExamplePage = detailItem.detail;
    if (!isLoad) _createWebView();
  }
}

class MyFAB extends StatelessWidget {
  final String url;
  final Icon icon;

  MyFAB({this.url, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 64,
        height: 64,
        padding: EdgeInsets.only(left: 20),
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () {
             URLLauncher().launchURL(url);
          },
          child: icon,
          backgroundColor: ButtonColorNormal,
        ));
  }
}
