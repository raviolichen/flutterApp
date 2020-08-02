import 'package:flutter/material.dart';
import 'modules/FeildItem.dart';
import 'modules/FeildItemList.dart';
import 'helps/helps.dart';

class ActivePage extends StatelessWidget {
  final feildItemList;
  final title;
  Map<String, TextEditingController> text_list_control = Map();

  ActivePage({this.title, this.feildItemList});

  Widget _buildListItem(BuildContext buildContext, FeildItem feildItem) {
    TextEditingController textEditingController = new TextEditingController();
    text_list_control[feildItem.fname] = textEditingController;
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: TextFormField(
          controller: textEditingController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: InputDecoration(
              hintText: feildItem.fname,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              hintStyle: TextStyle(color: Colors.grey)),
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final submitButton = Padding(
      padding: EdgeInsets.all(15.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        onPressed: () {
          String data = "";

          feildItemList.fitems.forEach((fkey) =>
              {data +=","+ fkey.fname + ":" + text_list_control[fkey.fname].text});

          Navigator.of(context).pop(data);
        },
        padding: EdgeInsets.all(12),
        color: appGreyColor,
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
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          maxLines: 3,
          softWrap: true,
        )));

    FeildWidgetList.add(submitButton);

    return Scaffold(
      backgroundColor: appDarkGreyColor,
      body: Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20.0),
            children: FeildWidgetList),
      ),
    );
  }
}
