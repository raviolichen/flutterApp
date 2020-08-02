import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'DetailEventPage.dart';
import 'package:flutter/material.dart';
import 'components/CusListTile.dart';
import 'DetailListPage.dart';
import 'DetailPage.dart';
import 'helps/globlefun.dart';
import 'helps/helps.dart';
import 'modules/RecordList.dart';
import 'modules/Record.dart';
import 'DataService.dart';

enum DetailType { DetailPage, DetailListPage, DetailEventPage }

class CheckBoxListViewPage extends StatefulWidget {
  final String RouterName;
  final String Id;
  final String appTitle;
  final DetailType detailType;
  final int voteCount;
  CheckBoxListViewPage(
      {this.Id,
      this.appTitle,
      this.RouterName,
      this.detailType,
      this.voteCount});

  @override
  State<StatefulWidget> createState() => _CheckBoxListViewPageState(
      Id, appTitle, RouterName, detailType, voteCount);
}
class _CheckBoxListViewPageState extends State<CheckBoxListViewPage> {
  String RouterName;
  String Id;
  DetailType detailType;
  String appTitle;
  int voteCount;
  final TextEditingController _filter = new TextEditingController();
  RecordList _records = new RecordList();
  RecordList _filteredRecords = new RecordList();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle;
  Widget searchButton;
  Map checkeditem = new Map<String, bool>();
  _CheckBoxListViewPageState(String Id, String appTitle, String RouterName,
      DetailType detailType, int voteCount) {
    this.detailType = detailType;
    this.RouterName = RouterName;
    this.appTitle = appTitle;
    this.Id = Id;
    this.voteCount = voteCount;
    _appBarTitle = new Text(appTitle);
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _resetRecords();
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
  void _resetRecords() {
    this._filteredRecords.records = new List();
    for (Record record in _records.records) {
      this._filteredRecords.records.add(record);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    searchButton = new IconButton(
      icon: _searchIcon,
      onPressed: () {
        _searchPressed();
      },
    );
    Widget _buildBar(BuildContext context) {
      return new AppBar(
        actions: <Widget>[searchButton],
        backgroundColor: ButtonColorSubmit,
        centerTitle: true,
        title: _appBarTitle,
      );
    }

    Widget _buildListItem(BuildContext context, Record record) {
      return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Checkbox(
                value: checkeditem[record.id]??false,
                onChanged: (bool value) {
                  setState(() {
                    if(voteCount>0||!value) {
                      checkeditem[record.id] = value;
                      if(value) {
                        voteCount--;
                      }
                      else
                        voteCount++;
                    }
                    else{
                      showMyDialog(context,"票數已經都投完囉!",true);
                    }
                  });
                }),
        Padding(
          padding: EdgeInsets.only(left: 50),
          child:
        Card(
            key: ValueKey(record.id),
            elevation: 2,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      new Border.all(color: CardBorderLineColor, width: 0.5)),
              child: CusListTile(
                  onTap: () {
                    NavigatorPage(context, record);
                  },
                  title: Text(record.title,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  subtitle: RichText(
                      text: TextSpan(
                    text: record.subtext,
                    style: TextStyle(color: Colors.black38, fontSize: 14),
                  )),
                  thumbnail: ClipOval(
                      child: Hero(
                          tag: "avatar_" + record.title + record.id,
                          child: AspectRatio(
                              aspectRatio: 1.2,
                              child: CachedNetworkImage(
                                  imageUrl: record.photo,
                                  height: 100,
                                  width: 100,
                                  placeholder: (context, url) => Center(
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator())),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover))))),
            ))),
      ]);
    }

    Widget _buildList(BuildContext context) {
      final submitButton = Padding(
        padding: EdgeInsets.all(15.0),
        child: RaisedButton(
          color: ButtonColorNormal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          onPressed: () {
            CompleteSubmit(context);
          },
          padding: EdgeInsets.all(12),
          //  color: appGreyColor,
          child: Text(submitButtonText, style: TextStyle(color: Colors.white)),
        ),
      );
      final cancelSubmit = Padding(
        padding: EdgeInsets.all(15.0),
        child: RaisedButton(
          color: ButtonColorNormal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          onPressed: () {
            CancelSubmiting(context);
          },
          padding: EdgeInsets.all(12),
          //  color: appGreyColor,
          child: Text(cancelSubmitText, style: TextStyle(color: Colors.white)),
        ),
      );
      if (!(_searchText.isEmpty)) {
        _filteredRecords.records = new List();
        for (int i = 0; i < _records.records.length; i++) {
          if (_records.records[i].title
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              _records.records[i].subtext
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
            _filteredRecords.records.add(_records.records[i]);
          }
        }
      }
      ListView listView=ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: this
            ._filteredRecords
            .records
            .map((data) => _buildListItem(context, data))
            .toList(),
      );

      return Column(
        children: <Widget>[
          Expanded(
            child:listView),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              submitButton,
              cancelSubmit
            ],
          )

        ],
      );
    }

    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
      body: _buildList(context),
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();
    _records.records = new List();
    _filteredRecords.records = new List();
    _getRecords();
  }

  void _getRecords() async {
    RecordList records = await RecordDataService().loadRecords(Id, RouterName);
    setState(() {
      for (Record record in records.records) {
        this._records.records.add(record);
        this._filteredRecords.records.add(record);
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: new TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.white),
            fillColor: Colors.white,
            hintText: '搜尋',
            hintStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(appTitle);
        _filter.clear();
      }
    });
  }

  void NavigatorPage(BuildContext context, Record record) {
    if (detailType == DetailType.DetailPage)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new DetailPage(record: record)));
    else if (detailType == DetailType.DetailEventPage) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => new DetailEventPagefix()));
    } else if (detailType == DetailType.DetailListPage) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new DetailListPage(record: record)));
    }
  }


  void CancelSubmiting(BuildContext context){
    String data="";
    Navigator.of(context).pop(data);
  }
  void CompleteSubmit(BuildContext context) async{
    bool isSubmit=await comfrirm(context,"送出後，將無法變更投票，是否繼續？");
    if(!isSubmit)return;
    String data = "";
    checkeditem.forEach((key, value) {
      if(value)
        data+=","+key;
    });
    if(data.length>0)
      data=data.substring(1);
    Navigator.of(context).pop(data);
  }
}
