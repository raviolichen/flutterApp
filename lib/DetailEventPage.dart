import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoApp/helps/GlobleValue.dart';
import 'package:demoApp/modules/EventItem.dart';
import 'package:flutter/material.dart';
import 'package:demoApp/EventPage.dart';
import 'package:demoApp/modules/FeildItemList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'DataService.dart';
import 'helps/globlefun.dart';
import 'helps/helps.dart';
import 'modules/detailEventitem.dart';

enum detailType { info, active, other }

class DetailEventPage extends StatelessWidget {
  final EventItem eventItem;
  _DetailEventPageStatful uDetailPage;

  DetailEventPage({this.eventItem});

  @override
  Widget build(BuildContext context) {
    uDetailPage = _DetailEventPageStatful(eventItem: eventItem);
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
            children: <Widget>[CachedNetworkImage(
              imageUrl: eventItem.url,
              placeholder: (context, url) => Center( child: SizedBox(width:30,height:30,child:CircularProgressIndicator())),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ), uDetailPage]),
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
  _DetailEventPageStatfulState createState() =>
      _DetailEventPageStatfulState(eventItem: eventItem);
}

class _DetailEventPageStatfulState extends State<_DetailEventPageStatful> {
  final EventItem eventItem;

  _DetailEventPageStatfulState({this.eventItem});

  String kNavigationExamplePage;
  bool isLoad;
  WebViewController _listController;
  double _heights;
  WebView _webview;
  bool isGetting = false;

  @override
  void initState() {
    super.initState();
    isLoad = false;
    _heights = 1.0;
    if (!isGetting) {
      isGetting = true;
      new Future.delayed(
          const Duration(milliseconds: 250), () => _loaddetailjson());
    }
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
    setState(() {

    });
  }

  Future<void> _loadhtml() async {
    await _listController.loadUrl(Uri.dataFromString(kNavigationExamplePage,
        mimeType: 'text/html', parameters: {'charset': 'utf-8'}).toString());
  }

  DetailEventItem detailItem;
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
          child: _webview,
        ),
        ActiveButton
      ]),
    );
  }
  void _loaddetailjson() async {
    detailItem = await DetailEventService().loadDetail(eventItem.eId,GlobleValue.userId);
    if(!isLoad)
      kNavigationExamplePage=htmlformat(detailItem.detail);
    _createWebView();
  }
  void showButton() {
    if (detailItem.eventType.toLowerCase().compareTo("info") != 0)
      ActiveButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(

          color: detailItem.ButtonEnable.compareTo("true")==0?ButtonColorNormal:ButtonColor_UNSelect,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: ()async{
            if(detailItem.ButtonEnable.compareTo("true")==0)
            CompleteSign();
          },
          padding: EdgeInsets.all(12),
          //  color: appGreyColor,
          child: Text(detailItem.ButtonText,
              style: TextStyle(color: Colors.white)),
        ),
      );

  }
  void CompleteSign () async{
    FeildItemList feildItemList = await FeildItemService()
        .loadFeildItemList(eventItem.eId, GlobleValue.userId);
    String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new EventPage(
                AppbarText: detailItem.ButtonText,
                title: eventItem.title,
                subtitle: eventItem.date,
                feildItemList: feildItemList)));
    if(result!=null) {
      _showMyDialog("完成報名中...",false);
      String isSuccess = await FeildItemService().postEeildValue(
          eventItem.eId, GlobleValue.userId.toString(), GlobleValue.token,
          result);
      if (isSuccess.toLowerCase().contains("isok")) {
        Navigator.pop(context);
        _showMyDialog("已經完成報名",true);
        setState(() {
          detailItem.ButtonText="編輯報名";
          showButton();
        });
      }
    }
  }
  Future<void> _showMyDialog(String text,bool isShowAction ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if(isShowAction)
          return AlertDialog(
            title: Text(text),
              actions: <Widget>[
          FlatButton(
          child: Text('確認'),
        onPressed: () {
        Navigator.of(context).pop();
        },
        ),
        ],
          );
          else
        return AlertDialog(
          title: Text(text),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }
}
