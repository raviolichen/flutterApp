import 'package:flutter/material.dart';
import 'modules/FeildItem.dart';
import 'helps/helps.dart';

class EventPage extends StatelessWidget {
  final feildItemList;
  final title;
  final subtitle;
  final AppbarText;
  Map<String, TextEditingController> text_list_control = Map();

  EventPage({this.AppbarText, this.title, this.subtitle, this.feildItemList});

  Widget _buildListItem(BuildContext buildContext, FeildItem feildItem) {
    TextEditingController textEditingController = new TextEditingController();
    text_list_control[feildItem.fname] = textEditingController;
    textEditingController.text=feildItem.fvalue;
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: TextFormField(
          controller: textEditingController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: InputDecoration(
              hintText: feildItem.fname,
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
    List<Widget> FeildWidgetList = this
        .feildItemList
        .fitems
        .map<Widget>((data) => _buildListItem(context, data))
        .toList();

    FeildWidgetList.insert(
        0,
        Center(
            child: RichText(
          text: TextSpan(
            text: this.title,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          maxLines: 3,
          softWrap: true,
        )));

    FeildWidgetList.insert(
        1,
        Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16,bottom: 20),
                child: RichText(
          text: TextSpan(
            text: this.subtitle,
            style: TextStyle(color: Colors.black87, fontSize: 12),
          ),
          maxLines: 3,
          softWrap: true,
        ))));

    FeildWidgetList.add(submitButton);
    return Scaffold(
      appBar: new AppBar(
          title: new Text(AppbarText), backgroundColor: ButtonColorSubmit),
      body: Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20.0),
            children: FeildWidgetList),
      ),
    );
  }
  void CompleteSubmit(BuildContext context){
    String data = "";
    feildItemList.fitems.forEach((fkey) => {
      data +=
           ",\""+fkey.fname + "\":\"" + text_list_control[fkey.fname].text+"\""
    });
    Navigator.of(context).pop("{"+data.substring(1)+"}");
  }
}
