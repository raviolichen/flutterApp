
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'helps/helps.dart';

class QrcodeScan extends StatefulWidget {
  @override
  _QrcodeScanState createState() => _QrcodeScanState();
}

class _QrcodeScanState extends State<QrcodeScan> {
  TextEditingController _outputController;

  @override
  void initState() {
    super.initState();
    this._outputController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          TextField(
            textAlign: TextAlign.center,
            controller: _outputController,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () => _scan(),
              padding: EdgeInsets.all(12),
             // color: appGreyColor,
              child: Text("show Web", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future _scan() async {
    String barcode = await scanner.scan();
    this._outputController.text = barcode;
  }
}
