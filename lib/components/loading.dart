import 'package:flutter/material.dart';
class LoadingHelper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(color: Colors.white),
        child:
        Center(
            child: CircularProgressIndicator()));
  }
}