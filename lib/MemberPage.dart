import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zhushanApp/components/loading.dart';
import 'ListViewPage.dart';
import 'helps/GlobleValue.dart';
import 'package:flutter/material.dart';
import 'components/CusListTile.dart';
import 'LoginPage.dart';
import 'helps/globlefun.dart';
import 'helps/helps.dart';
import 'modules/RecordList.dart';
import 'modules/Record.dart';
import 'DataService.dart';

class MemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemberPageState();
}
class MemberPageState extends State<MemberPage> with  TickerProviderStateMixin{
  RecordList _records = new RecordList();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget _buildListItem(BuildContext context, Record record) {
      return Container(
        key: ValueKey(record.id),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: CardBorderLineColor, width: 0.5))),
          child: CusListTile(
            onTap: () {
              NavigatorPage(context,record);
            },
            title: Text(record.title,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 24)),
            subtitle: RichText(
              text: TextSpan(
                text: record.subtext,
                style: TextStyle(color: Colors.black38,fontSize: 16),
                children: <TextSpan>[
                  TextSpan(text: "\n"),
                  TextSpan(text: record.data),
                ],

              ),
            ),
            thumbnail: ClipOval(
                child: Hero(
                    tag: record.id,
                    child:
                    AspectRatio(
                      aspectRatio: 1,
                        child:
                    CachedNetworkImage(
                        imageUrl: record.photo,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) => Center( child: SizedBox(width:30,height:30,child:CircularProgressIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover)))),
          ),
        ),
      );
    }
    Widget _buildList(BuildContext context) {
      String _goldnum=GlobleValue.Golds==null?"0":GlobleValue.Golds;
      String _userId=GlobleValue.userId.toString().padLeft(10, '0');
      List<Widget> recordlist = this
          ._records
          .records
          .map((data) => _buildListItem(context, data))
          .toList();
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 50),
        itemCount: recordlist.length + 1,
        // +1 because you are showing one extra widget.
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(children: <Widget>[
              Container(
                color: ButtonColor_UNSelect,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                Expanded(
                    flex: 1,
                child: Align(
                    alignment:Alignment.center,
                    child:Container(
                        height: 150,
                        width: 150,
                        padding: EdgeInsets.all(8),
                        child:
                        AspectRatio (
                          aspectRatio: 1,
                          child:
                          ClipOval(
                            child: Container(
                              color: Colors.white,
                                child: Icon(Icons.perm_contact_calendar
                                    ,color: Colors.amber,
                                size: 120.0,
                                semanticLabel: 'Text to announce in accessibility modes'))
                            )),
                      ))),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                        child:
                            Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                                child:RichText(
                              text: TextSpan(
                                text: GlobleValue.userName+"\n",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                                children: <TextSpan>[
                                  TextSpan(text: _userId+"\n", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16)),
                                  TextSpan(text: "金幣數量:"+_goldnum ,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16)),
                                ],
                              ),
                            )),
                              Padding(
                                padding: EdgeInsets.only(top: 5,bottom: 15),
                                child: RaisedButton(
                                  color: ButtonColorNormal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () {
                                    ShowQRcodeImage(context,QrImage(
                                      data: encydata(GlobleValue. proxycode,GlobleValue.deviceId),
                                      version: QrVersions.auto,
                                      size: 200,
                                      gapless: false,
                                    ));
                                  },
                                  //  color: appGreyColor,
                                  child: Text("顯示裝置QRcode", style: TextStyle(color: Colors.white)),
                                ),
                              )
                            ])
                         ,
                      )),
                    ]),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.only(top: 20),
                child: RichText(
                  text: TextSpan(
                    text: "活動歷程",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black54),
                  ),
                ),
              )
            ]);
          }
          int numberOfExtraWidget =
              1; // here we have 1 ExtraWidget i.e Container.
          index = index - numberOfExtraWidget; // index of actual post.
          return recordlist[index];
        },
      );
    }
    return
      isGetting?LoadingHelper(): FadinHelp(this,AnimatedSwitcher(
        duration: Duration(milliseconds: 350),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween=Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
          return MySlideTransition(
            child: child,
            position: tween.animate(animation),
          );
        },child:
      GlobleValue.userId==null? LoginPage(this):Scaffold(
      appBar: new AppBar(
        title: new Text(memberappTitle),
        backgroundColor: ButtonColorSubmit,
      ),
      backgroundColor: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
      body: _buildList(context),
      resizeToAvoidBottomPadding: false,
    )));
  }
  @override
  void initState() {
    super.initState();
    _records.records = new List();
    _getRecords();
  }
  bool isGetting=false;
  void _getRecords() async {
    isGetting=true;
    await getId(context,true);
    if( GlobleValue.userId!=null)
    _records = await RecordDataService().loadRecords(GlobleValue.userId.toString(),GlobleValue.UserSlvGetAPI);
    setState(() {
      isGetting=false;
    });
  }
  void NavigatorPage(BuildContext context,Record record){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new ListViewPage(RouterName: GlobleValue.OwnerSlvGetAPI,appTitle: record.title,Id:record.id+"&userId="+GlobleValue.userId.toString().toString(),detailType: DetailType.DetailPage,)));
  }
}
class MySlideTransition extends AnimatedWidget {
  MySlideTransition({
    Key key,
    @required Animation<Offset> position,
    this.transformHitTests = true,
    this.child,
  })
      : assert(position != null),
        super(key: key, listenable: position) ;

  Animation<Offset> get position => listenable;
  final bool transformHitTests;
  final Widget child;
  bool isRighttoLeft;
  @override
  Widget build(BuildContext context) {
    Offset offset=position.value;
    //动画反向执行时，调整x偏移，实现“从左边滑出隐藏”
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}
