import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'components/banner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/CusListTile.dart';
import 'helps/globlefun.dart';
import 'modules/DetailListItem.dart';
import 'modules/Record.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'DataService.dart';
import 'helps/helps.dart';

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
class DetailListPage extends StatefulWidget {
  final Record record;

  DetailListPage({this.record});

  @override
  _DetailListPageState createState() =>
      _DetailListPageState(record: this.record);
}
class _DetailListPageState extends State<DetailListPage> {
  final Record record;
  String kNavigationExamplePage;
  bool isLoad;
  WebViewController _listController;
  double _heights;
  WebView _webview;

  _DetailListPageState({this.record});

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
        Uri.dataFromString(kNavigationExamplePage, mimeType: 'text/html', parameters: { 'charset': 'utf-8' })
            .toString());
  }

  DetailListItem detailItem;
  Widget ActiveButton = Container();

  Widget _buildItem(storeProduct s) {
    return CusListTile(
      cIcon:Icon(Icons.verified_user,size: 0,) ,
      title: Text(s.pName,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 20)),
      subtitle: RichText(
          text: TextSpan(
        text: s.pText,
        style: TextStyle(color: Colors.black38,fontSize: 16),
      )),
      thumbnail:
      AspectRatio(
        aspectRatio: 1,
        child:
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: s.pImage,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text(record.title),
          backgroundColor: ButtonColorSubmit,
        ),
        body: Stack(children: <Widget>[
          Hero(
            tag: "avatar_" +record.title+ record.id.toString(),
            child: ListView.builder(
              itemCount: isLoad ? detailItem.products.length + 3 : 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return c_Banner(isLoad ? detailItem.potos : [record.photo]);
                } else if (index == 1) {
                  return Container(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start ,
                        children: <Widget>[                      !isLoad
                          ? Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: RichText(
                                text: TextSpan(
                                    text: "",
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: record.title + "\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24)),
                                      TextSpan(
                                          text: record.subtext + "\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      TextSpan(
                                          text: record.data,
                                          style: TextStyle(fontSize: 16)),
                                    ]),
                              )),
                      Container(
                        height: _heights ?? 0,
                        child: _webview,
                      ),
                      ActiveButton,
                      isLoad ? RichText( text:TextSpan( text:"產品列表", style: TextStyle(fontSize: 20,color: Colors.black54))) : Container()
                    ]),
                  );
                } else if (!isLoad || index == detailItem.products.length + 2) {
                  return Container(
                    height: 60,
                  );
                } else
                  return _buildItem(detailItem.products[index - 2]);
              },
            ),
          ),
          isLoad
              ? Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: <Widget>[
                      MyFAB(url: detailItem.StoreWeb, icon: Icon(Icons.web)),
                      MyFAB(
                          url: detailItem.storeWebF, icon: Icon(Icons.people)),
                      MyFAB(
                          url: detailItem.stroeMapLocation,
                          icon: Icon(Icons.map))
                    ],
                  ))
              : Container(),
        ]));
  }

  void _loaddetailjson() async {
    detailItem = await DetailListDataService().loadDetail(record.id);
    kNavigationExamplePage=htmlformat(detailItem.storeHtml);
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
