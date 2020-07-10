import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoApp/ListViewPage.dart';
import 'package:demoApp/helps/GlobleValue.dart';
import 'package:flutter/material.dart';
import 'CusListTile.dart';
import 'LoginPage.dart';
import 'helps/helps.dart';
import 'modules/RecordList.dart';
import 'modules/Record.dart';
import 'DataService.dart';

class MemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemberPageState();
}
class MemberPageState extends State<MemberPage> {
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
                    color: Colors.black54, fontWeight: FontWeight.bold)),
            subtitle: RichText(
              text: TextSpan(
                text: record.subtext,
                style: TextStyle(color: Colors.black38),
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
                    CachedNetworkImage(
                        imageUrl: record.photo,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) => Center( child: SizedBox(width:30,height:30,child:CircularProgressIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover))),
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
                child: Container(
                        height: 150,
                        width: 150,
                        padding: EdgeInsets.all(8),
                        child: ClipOval(
                            child: Container(
                              color: Colors.white,
                                child: Icon(Icons.perm_contact_calendar
                                    ,color: Colors.amber,
                                size: 120.0,
                                semanticLabel: 'Text to announce in accessibility modes'))
                            ),
                      )),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                        child:
                          RichText(
                            text: TextSpan(
                              text: GlobleValue.userName+"\n",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 32),
                              children: <TextSpan>[
                                TextSpan(text: _userId+"\n", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16)),
                                TextSpan(text: "金幣數量:"+_goldnum ,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16)),
                              ],
                            ),
                          ),
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
    return GlobleValue.userId==null? LoginPage(this):Scaffold(
      appBar: new AppBar(
        title: new Text(memberappTitle),
        backgroundColor: ButtonColorSubmit,
      ),
      backgroundColor: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
      body: _buildList(context),
      resizeToAvoidBottomPadding: false,
    );
  }
  @override
  void initState() {
    super.initState();
    _records.records = new List();
    _getRecords();
  }
  void _getRecords() async {
    _records = await RecordService().loadRecords(GlobleValue.userId.toString(),GlobleValue.UserSlvGetAPI);
    setState(() {});
  }
  void NavigatorPage(BuildContext context,Record record){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new ListViewPage(RouterName: GlobleValue.OwnerSlvGetAPI,appTitle: record.title,Id:record.id.toString(),detailType: DetailType.DetailPage,)));
  }
}
