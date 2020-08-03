import 'package:cached_network_image/cached_network_image.dart';
import 'DetailEventPage.dart';
import 'package:flutter/material.dart';
import 'components/CusListTile.dart';
import 'DetailListPage.dart';
import 'DetailPage.dart';
<<<<<<< HEAD
=======
import 'components/loading.dart';
import 'helps/globlefun.dart';
>>>>>>> origin/master
import 'helps/helps.dart';
import 'modules/RecordList.dart';
import 'modules/Record.dart';
import 'DataService.dart';

enum DetailType { DetailPage, DetailListPage, DetailEventPage }

class ListViewPage extends StatefulWidget {
  final String RouterName;
  final String Id;
  final String appTitle;
  final DetailType detailType;
  ListViewPage({this.Id,this.appTitle, this.RouterName,this.detailType});

  @override
  State<StatefulWidget> createState() => _ListViewPageState(Id,appTitle, RouterName,detailType);
}
<<<<<<< HEAD
class _ListViewPageState extends State<ListViewPage> {
=======
class _ListViewPageState extends State<ListViewPage> with TickerProviderStateMixin {
>>>>>>> origin/master
  String RouterName;
  String Id;
  DetailType detailType;
  String appTitle;
  final TextEditingController _filter = new TextEditingController();
  RecordList _records = new RecordList();
  RecordList _filteredRecords = new RecordList();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle ;
  Widget searchButton;
  _ListViewPageState(String Id,String appTitle ,String RouterName,DetailType detailType) {
    this.detailType=detailType;
    this.RouterName = RouterName;
    this.appTitle=appTitle;
    this.Id=Id;
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
      return Card(
        key: ValueKey(record.id),
        elevation: 2,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
              border: new Border.all(color: CardBorderLineColor, width: 0.5)),
          child: CusListTile(
            onTap: () {
              NavigatorPage(context,record);
            },
            title: Text(record.title,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 20)),
            subtitle: RichText(
                text: TextSpan(
              text: record.subtext,
              style: TextStyle(color: Colors.black38,fontSize: 14),
            )),
            thumbnail: ClipOval(
                child: Hero(
                    tag: "avatar_" +record.title +record.id,
                    child:AspectRatio (
                      aspectRatio: 1.2,
                        child:CachedNetworkImage(
                        imageUrl: record.photo,
                        height: 100,
                        width: 100,
                        placeholder: (context, url) => Center( child: SizedBox(width:30,height:30,child:CircularProgressIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover))

                )),
          ),
        ),
      );
    }

    Widget _buildList(BuildContext context) {
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
      return ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: this
            ._filteredRecords
            .records
            .map((data) => _buildListItem(context, data))
            .toList(),
      );
    }
<<<<<<< HEAD

    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
      body: _buildList(context),
=======
    final fadincontroller=AnimationController(vsync:this,duration:Duration(milliseconds: 300) );
    final fadinanimation=Tween(begin: 0.0,end: 1.0).animate(fadincontroller);
    fadincontroller.forward();
    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
      body:isGetting?LoadingHelper(): FadinHelp(this,_buildList(context)),
>>>>>>> origin/master
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
<<<<<<< HEAD
  void _getRecords() async {
    RecordList records = await RecordDataService().loadRecords(Id, RouterName);
    setState(() {
=======
  bool isGetting=false;
  void _getRecords() async {
    isGetting=true;
    RecordList records = await RecordDataService().loadRecords(Id, RouterName);
    setState(() {
      isGetting=false;
>>>>>>> origin/master
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
  void NavigatorPage(BuildContext context,Record record){
    if(detailType==DetailType.DetailPage)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            new DetailPage(record: record)));
    else if(detailType==DetailType.DetailEventPage){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              new DetailEventPagefix()));
    }
    else if(detailType==DetailType.DetailListPage){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              new DetailListPage(record: record)));
    }
  }
}
