import 'dart:async';
import 'package:demoApp/modules/EventItem.dart';
import 'package:flutter/material.dart';
import 'package:demoApp/EventPage.dart';
import 'package:demoApp/modules/FeildItemList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'DataService.dart';
import 'helps/helps.dart';
import 'modules/detailitem.dart';

enum detailType { info, active, other }
class DetailEventPage extends StatelessWidget {
  final EventItem eventItem;
  _DetailEventPageStatful uDetailPage ;
  DetailEventPage({this.eventItem});
  @override
  Widget build(BuildContext context) {
    uDetailPage = _DetailEventPageStatful(eventItem:eventItem);
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text(eventItem.title),
        backgroundColor: ButtonColorSubmit,
      ),
      body: Hero(
        tag: "avatar_" + eventItem.eId.toString(),
        child: ListView(
            children: <Widget>[new Image.network(eventItem.url), uDetailPage]),
      ),
    );
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
class _DetailEventPageStatful extends StatefulWidget {
  final EventItem eventItem;
  _DetailEventPageStatful({this.eventItem});
  @override
  _DetailEventPageStatfulState createState() => _DetailEventPageStatfulState(eventItem:eventItem);
}
class _DetailEventPageStatfulState extends State<_DetailEventPageStatful> {
  final EventItem eventItem;
  _DetailEventPageStatfulState({this.eventItem});
  String kNavigationExamplePage;
  bool isLoad;
  WebViewController _listController;
  double _heights;
  WebView _webview;
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
          return NavigationDecision.prevent;
      },
      onPageFinished: (some) async {
        //await _listController.evaluateJavascript("document.getElementsByTagName(\"iframe\")[0].width=document.body.clientWidth");
        double height2 = double.parse(await _listController
            .evaluateJavascript("document.body.clientHeight;"));
        setState(() {
          showButton();
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
        Uri.dataFromString(kNavigationExamplePage, mimeType: 'text/html', parameters: { 'charset': 'utf-8' })
            .toString());
  }
  DetailItem detailItem;
  Widget ActiveButton = Container();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        !isLoad
            ? Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : SizedBox(),
        Container(
          height: _heights ?? 0,
          child:  _webview,
        ),
        ActiveButton
      ]),
    );
  }
  void _loaddetailjson() async {
    detailItem = await DetailService().loadDetail(eventItem.eId);
    kNavigationExamplePage = detailItem.detail;
    _createWebView();
  }
  void showButton() {
    if (detailItem.eventType.toLowerCase().compareTo("info") != 0)
      ActiveButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          color: ButtonColorNormal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            FeildItemList feildItemList =
                await FeildItemService().loadFeildItemList(userId);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new EventPage(
                      AppbarText: detailItem.ButtonText,
                        title: eventItem.title,
                        subtitle: eventItem.date,
                        feildItemList: feildItemList)));
          },
          padding: EdgeInsets.all(12),
          //  color: appGreyColor,
          child: Text(detailItem.ButtonText,
              style: TextStyle(color: Colors.white)),
        ),
      );
  }
}
