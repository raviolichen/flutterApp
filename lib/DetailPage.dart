import 'dart:async';
import 'dart:convert';
import 'helps/GlobleValue.dart';
import 'package:flutter/material.dart';
import 'components/banner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helps/globlefun.dart';
import 'modules/DetailItem.dart';
import 'modules/Record.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'DataService.dart';
import 'helps/helps.dart';
import 'modules/detailEventitem.dart';
import 'modules/RecordList.dart';

enum detailType { info, active, other }

class URLLauncher {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class DetailPage extends StatefulWidget {
  final Record record;

  DetailPage({this.record});

  @override
  _DetailPageStatefulState createState() =>  _DetailPageStatefulState(record: this.record);
}

class _DetailPageStatefulState extends State<DetailPage> {
  String kNavigationExamplePage;
  bool isLoad;
  WebViewController _listController;
  double _heights;
  WebView _webview;
  final Record record;

  _DetailPageStatefulState({this.record});

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
        if(!isLoad)
          return NavigationDecision.navigate;
        return NavigationDecision.prevent;
      },
      onPageFinished: (some) async {
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
        Uri.dataFromString(kNavigationExamplePage, mimeType: 'text/html',
            parameters: { 'charset': 'utf-8'})
            .toString());
  }

  DetailItem detailItem;
  Widget ActiveButton = Container();

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
            tag: "avatar_" + record.id,
            child: ListView(children: <Widget>[
              c_Banner(isLoad?detailItem.potos:[record.photo]),
              Container(
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
              ),
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
                  record.url.length > 0 ? MyFAB(
                      url: record.url, icon: Icon(Icons.map)) : Container()
                ],
              )),
        ]));
  }

  void _loaddetailjson() async {
    detailItem = await DetailDataService().loadDetail(record.id);
   if(!isLoad)
    kNavigationExamplePage=htmlformat(detailItem.html);
   _createWebView();
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
