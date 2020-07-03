import 'package:demoApp/ListViewPage.dart';
import 'package:flutter/material.dart';
import 'CusListTile.dart';
import 'helps/helps.dart';
import 'modules/RecordList.dart';
import 'modules/Record.dart';
import 'DataService.dart';

class MemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemberPageState();
}
class _MemberPageState extends State<MemberPage> {
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
                    child: Image.network(
                      record.photo,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ))),
          ),
        ),
      );
    }

    Widget _buildList(BuildContext context) {
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
                      Container(
                        height: 150,
                        padding: EdgeInsets.all(8),
                        child: ClipOval(
                            child: Image.network(
                                "https://s.yimg.com/zp/images/59ACE79113CE7CD01D456193B59551BD27DCE048")),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("User Name"),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0)),
                          Text("123456789"),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0)),
                          Text("金幣數量:372"),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0)),
                        ],
                      ),
                    ]),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.only(top: 20),
                child: Text("活動歷程"),
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
    return Scaffold(
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
    _records = await RecordService().loadRecords("123456", "history");
    setState(() {});
  }
  void NavigatorPage(BuildContext context,Record record){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new ListViewPage(RouterName: "collect",appTitle: record.title,Id:record.id.toString(),detailType: DetailType.DetailPage,)));
  }
}
