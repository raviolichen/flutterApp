import 'helps/GlobleValue.dart';
import 'modules/TypeItemList.dart';
import 'package:flutter/material.dart';
import 'ListViewPage.dart';
import 'helps/helps.dart';
import 'DataService.dart';
import 'components/CusListTile.dart';
import 'modules/TypeItem.dart';

class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() {
    return _TypePageState();
  }
}
class _TypePageState extends State<TypePage> {
  TypeItemList typeItemList=new TypeItemList();
  Widget _appBarTitle = new Text(TypePageappTitle);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget _buildBar(BuildContext context) {
      return new AppBar(
          elevation: 10.0,
          backgroundColor: ButtonColorSubmit,
          centerTitle: true,
          title: _appBarTitle
      );
    }

    Widget _buildListItem(BuildContext context, TypeItem typeitem) {
      return
        Container(
          height: 250,
          child:
        Card(
          elevation: 2.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white24),
            child: CusListTile_ImageFirst(
              title:
              RichText(
                  text:TextSpan(text:typeitem.TName,
                  style: TextStyle(color: Colors.black54,fontSize: 20))
              ),
              thumbnail: typeitem.Images,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new ListViewPage(
                            Id:typeitem.TId,appTitle: typeitem.TName,RouterName: GlobleValue.StoreListGetAPI,detailType: DetailType.DetailListPage,)));
              },
            ),
          )));
    }

    Widget _buildList(BuildContext context) {
      return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: this
            .typeItemList.typeItemList.map((data) => _buildListItem(context, data))
            .toList(),
      );
    }

    return Scaffold(
      appBar: _buildBar(context),
      //backgroundColor: appDarkGreyColor,
      body:_buildList(context),
      resizeToAvoidBottomPadding: false,
    );
  }
  @override
  void initState() {
    super.initState();
    _getRecords();
    typeItemList.typeItemList=new List();
  }
  void _getRecords() async {
    typeItemList = await TypePageDataService().loadData();
    setState(() {
    });
  }
}
