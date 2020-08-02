import 'dart:io';

import 'package:zhushanApp/helps/globlefun.dart';

import 'helps/GlobleValue.dart';
import 'package:flutter/material.dart';
import 'DataService.dart';
import 'MemberPage.dart';
import 'helps/helps.dart';

class LoginPage extends StatefulWidget{
  final MemberPageState parent;
  LoginPage(this.parent);
  @override
  State<StatefulWidget> createState() => _LoginPageState(parent);
}
class _LoginPageState extends State<LoginPage>{
  final MemberPageState parent;
  _LoginPageState(this.parent);
  Map<String, TextEditingController> text_list_control = Map();

  Widget _buildListItem(BuildContext buildContext, String feildItem,String hint,TextInputType textInputType) {
    TextEditingController textEditingController = new TextEditingController();
    text_list_control[feildItem] = textEditingController;
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: TextFormField(
          controller: textEditingController,
          keyboardType: textInputType,
          maxLines: 1,
          decoration: InputDecoration(
              hintText:hint,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    32.0,
                  ),
                  borderSide: BorderSide(color: CardBorderLineColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    32.0,
                  ),
                  borderSide: BorderSide(color: CardBorderLineColor)),
              hintStyle: TextStyle(color: Colors.black26)),
          style: TextStyle(
            color: Colors.black,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final submitButton = Padding(
      padding: EdgeInsets.all(15.0),
      child: RaisedButton(
        color: ButtonColorNormal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        onPressed: () async {
          String data="";
          showLoading(context);
          text_list_control.keys.forEach((i) {
              data+="\""+i+"\":\""+text_list_control[i].text+"\",";
          });
          data+="\"deviceId\":\""+GlobleValue.deviceId+"\"";
         var result=await UserDataService().postUser("{"+data+"}");
          if(isDiaglogShowing) {
            Navigator.pop(context);
          }
          if(result["userId"].toString().compareTo("0")!=0){
            parent.setState(() {
              GlobleValue.userId = int.parse(result["userId"]);
              GlobleValue.token = result["token"];
              GlobleValue.userName = result["userName"];
              GlobleValue.Golds = result["Golds"];
            });
          }
          else{
            AlertDialog(
              title: Text("登入失敗，請確認網路狀態"),
              actions: <Widget>[
                FlatButton(
                  child: Text('確認'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        },
        padding: EdgeInsets.all(12),
        //  color: appGreyColor,
        child: Text(submitButtonText, style: TextStyle(color: Colors.white)),
      ),
    );
    List<Widget> FeildWidgetList =new List();
    FeildWidgetList.add(
        Center(
            child: RichText(
              text: TextSpan(
                text: "您必須須實名登陸後才能進行報名及其他活動",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              maxLines: 3,
              softWrap: true,
            )));
    FeildWidgetList.add(_buildListItem(context,"userName", "使用者名稱",TextInputType.text));
    FeildWidgetList.add(_buildListItem(context, "phone","手機號碼",TextInputType.phone));
    FeildWidgetList.add(submitButton);
   return  Scaffold(
      appBar: new AppBar(
          title: new Text("實名登記"), backgroundColor: ButtonColorSubmit),
      body: Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20.0),
            children: FeildWidgetList),
      ),
    );

  }
}