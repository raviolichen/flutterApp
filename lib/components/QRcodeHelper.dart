<<<<<<< HEAD
=======
import 'dart:developer';

>>>>>>> origin/master
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zhushanApp/helps/GlobleValue.dart';
import 'package:zhushanApp/helps/globlefun.dart';
import 'package:zhushanApp/modules/Record.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../DataService.dart';
import '../DetailPage.dart';

<<<<<<< HEAD
class QRcodeHelper{
  final context;
=======
class QRcodeHelper {
  final context;

>>>>>>> origin/master
  QRcodeHelper(this.context);

  ScanResult scanResult;
  final _flashOnController = TextEditingController(text: "開啟閃光燈");
  final _flashOffController = TextEditingController(text: "關閉閃光燈");
  final _cancelController = TextEditingController(text: "取消");
  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  bool isconfirmshoing;
<<<<<<< HEAD
=======

>>>>>>> origin/master
  Future<ScanResult> scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );
      return await BarcodeScanner.scan(options: options);
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        result.rawContent = '無法取得相機權限';
      } else {
        result.rawContent = '不明錯誤: $e';
      }
      return result;
    }
  }
<<<<<<< HEAD
  // ignore: non_constant_identifier_names
  void QRCodePostResult() async {
    scanResult = await scan();
    if (scanResult.type == ResultType.Barcode) {
      showLoading(context);
      Map<String, dynamic>  data = await QRcodeDataService().postQrcodeValue(
          GlobleValue.userId, GlobleValue.token, scanResult.rawContent);
      if(isDiaglogShowing)
        Navigator.pop(context);
      QRcodeResult(data);
    }
  }
  void QRcodeResult( Map<String, dynamic>  data){
    if (data!=null) {
      String message=data["result"];
      String coinId=data["Id"].toString();
      bool needConfirm=data["confirm"]!=null&&data["confirm"].toString().compareTo("true")==0;
      if(needConfirm)
        _showMyDialogConfirm(data);
      else {
        bool isGuid = data["isGuid"] != null &&
            data["isGuid"].toString().compareTo("true") == 0;
        _showMyDialog(message, coinId != null && isGuid, coinId,data["name"]);
      }
    }
  }
  Future<void> _showMyDialogConfirm( Map<String, dynamic> data) async {
    isconfirmshoing=true;
=======

  // ignore: non_constant_identifier_names
  void QRCodePostResult() async {
    scanResult = await scan();
    String decodeResult;
    if (scanResult.type == ResultType.Barcode) {
      if (GlobleValue.proxy != null && GlobleValue.proxy) {
        decodeResult =
            decryptdata(GlobleValue.proxycode, scanResult.rawContent);
        if (decodeResult != null && decodeResult.length > 0) {
          await showMyDialog(context, "資訊掃描成功，請掃描要兌換的QRCode", true);
          scanResult = await scan();
        }
      }
      showLoading(context);
      try {
        Map<String, dynamic> data = await QRcodeDataService().postQrcodeValue(
            GlobleValue.userId, GlobleValue.token, scanResult.rawContent, null);
        if (isDiaglogShowing) Navigator.pop(context);
        QRcodeResult(data, decodeResult);
      }
      catch(e){
        if (isDiaglogShowing) Navigator.pop(context);
        await showMyDialog(context, "失敗，請檢查網路並確認掃描的QRCode。", true);
      }
    }
  }

  void QRcodeResult(Map<String, dynamic> data, String proxydata) {
    if (data != null) {
      String message = data["result"];
      String coinId = data["Id"].toString();
      bool needConfirm = data["confirm"] != null &&
          data["confirm"].toString().compareTo("true") == 0;
      if (needConfirm)
        _showMyDialogConfirm(data, proxydata);
      else {
        bool isGuid = data["isGuid"] != null &&
            data["isGuid"].toString().compareTo("true") == 0;
        _showMyDialog(message, coinId != null && isGuid, coinId, data["name"]);
      }
    }
  }

  Future<void> _showMyDialogConfirm(
      Map<String, dynamic> data, String proxydata) async {
    isconfirmshoing = true;
>>>>>>> origin/master
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
<<<<<<< HEAD
          title: Text("是否兌換\""+data["name"]+"\""),
          content:
          SizedBox(
              height: 150,
              width: 250,
              child:Column(
=======
          title: Text("是否兌換\"" + data["name"] + "\""),
          content: SizedBox(
              height: 150,
              width: 250,
              child: Column(
>>>>>>> origin/master
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: data["potos"],
                      height: 150,
                      width: 250,
<<<<<<< HEAD
                      placeholder: (context, url) => Center( child: SizedBox(width:30,height:30,child:CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover)
                ],
              )

          ),
=======
                      placeholder: (context, url) => Center(
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover)
                ],
              )),
>>>>>>> origin/master
          actions: <Widget>[
            FlatButton(
              child: Text('確認'),
              onPressed: () async {
<<<<<<< HEAD
                Map<String, dynamic>  data = await QRcodeDataService().postQrcodeValue(
                    GlobleValue.userId, GlobleValue.token, scanResult.rawContent+",true");
                QRcodeResult(data);
=======
                Map<String, dynamic> data = await QRcodeDataService()
                    .postQrcodeValue(GlobleValue.userId, GlobleValue.token,
                        scanResult.rawContent + ",true", proxydata);
                QRcodeResult(data, proxydata);
>>>>>>> origin/master
              },
            ),
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
<<<<<<< HEAD
    ).then((_) => isconfirmshoing=false);
  }
  Future<void> _showMyDialog(String text,bool isShowAction,String coinId ,String title) async {
=======
    ).then((_) => isconfirmshoing = false);
  }

  Future<void> _showMyDialog(
      String text, bool isShowAction, String coinId, String title) async {
>>>>>>> origin/master
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
<<<<<<< HEAD
        if(isShowAction)
=======
        if (isShowAction)
>>>>>>> origin/master
          return AlertDialog(
            title: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('確認前往解說'),
                onPressed: () {
<<<<<<< HEAD
                  Record record=new Record(id:coinId,photo: "",title: title,data: "",url: "",subtext: "");
=======
                  Record record = new Record(
                      id: coinId,
                      photo: "",
                      title: title,
                      data: "",
                      url: "",
                      subtext: "");
>>>>>>> origin/master
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
<<<<<<< HEAD
                          new DetailPage(record: record)));
=======
                              new DetailPage(record: record)));
>>>>>>> origin/master
                },
              ),
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        else
          return AlertDialog(
            title: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('確定'),
                onPressed: () {
<<<<<<< HEAD
                  if(isconfirmshoing!=null&&isconfirmshoing)
=======
                  if (isconfirmshoing != null && isconfirmshoing)
>>>>>>> origin/master
                    Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/master
