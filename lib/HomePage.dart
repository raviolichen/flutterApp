import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoApp/modules/EventItem.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'CusListTile.dart';
import 'helps/GlobleValue.dart';
import 'helps/helps.dart';
import 'modules/HomePageJson.dart';
import 'modules/RecordList.dart';
import 'modules/Record.dart';
import 'DataService.dart';
import 'DetailEventPage.dart';
import 'banner.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   HomePageData _datas = new HomePageData();
  List<String> _imgData;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget _buildListItem(BuildContext context, EventItem record) {
      return Card(
        key: ValueKey(record.eId),
        elevation: 2,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
              border: new Border.all(color: CardBorderLineColor, width: 0.5)),
          child: CusListTile(
            onTap: () {
              NavigatorPage(context, record);
            },
            title: Text(record.title,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold)),
            subtitle: RichText(
                text: TextSpan(
              text: record.date,
              style: TextStyle(color: Colors.black38),
            )),
            thumbnail: ClipOval(
                child: Hero(
                    tag: "avatar_" + record.eId.toString(),
                    child: CachedNetworkImage(
                          width: 100,
                          height: 100,
                          imageUrl: record.url,
                          placeholder: (context, url) =>Center( child: SizedBox(width:30,height:30,child:CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                )),
          ),
        ),
      );
    }

    Widget _buildList(BuildContext context) {
      List<Widget> recordlist = this
          ._datas
          .eventList
          .map((data) => _buildListItem(context, data))
          .toList();
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 50),
        itemCount: recordlist.length + 1,
        // +1 because you are showing one extra widget.
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _imgData.length == 0
                ? Container()
                : Container(height: 250, child: c_Banner(_imgData));
          }
          int numberOfExtraWidget =
              1; // here we have 1 ExtraWidget i.e Container.
          index = index - numberOfExtraWidget; // index of actual post.
          return recordlist[index];
        },
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
      body: _buildList(context),
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();
    _datas.eventList = new List();
    // _datas.banner=new List();
    _imgData = new List();
    _getRecords();
  }

  bool isGetting = false;

  void _getRecords() async {
    if (!isGetting) {
      isGetting=true;
      _datas = await HomePageJsonService().loadDetail();
    }
    setState(() {
      _imgData = _datas.banner;
    });
  }

  void NavigatorPage(BuildContext context, EventItem record) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new DetailEventPage(
                  eventItem: record,
                )));
  }
}
