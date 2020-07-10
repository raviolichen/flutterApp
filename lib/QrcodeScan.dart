import 'package:demoApp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
class QrcodeScan extends StatefulWidget {
  @override
  _QrcodeScanState createState() => _QrcodeScanState();
}

class _QrcodeScanState extends State<QrcodeScan> with TickerProviderStateMixin {
  ScanResult scanResult;

  final _flashOnController = TextEditingController(text: "開啟閃光燈");
  final _flashOffController = TextEditingController(text: "關閉閃光燈");
  final _cancelController = TextEditingController(text: "取消");
  var _numberOfCameras = 0;
  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  // ignore: type_annotate_public_apis
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      if(_numberOfCameras>0)
      setState(() {
        scan();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
      body: Container(),
      resizeToAvoidBottomPadding: false,
    );
  }
  Future scan() async {
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
      var result = await BarcodeScanner.scan(options: options);
      setState(() => {
     // Navigator.pop(context,result)
      });
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = '無法取得相機權限';
        });
      } else {
        result.rawContent = '不明錯誤: $e';
      }

    }
  }
}