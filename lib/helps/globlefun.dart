import 'package:device_info/device_info.dart';
import 'package:encrypt/encrypt.dart' as _encypt;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zhushanApp/helps/CacheHelp.dart';
import '../DataService.dart';
import 'GlobleValue.dart';
import 'SQLiteHelp.dart';
String htmlformat(String data) {
  String newStrng = "";
  RegExp video = RegExp(r'<oembed url="(.*)"><\/oembed>');
  Iterable<Match> matches = video.allMatches(data);
  if (matches != null && matches.length > 0) {
    String ytid = matches.elementAt(0).group(1).split('?')[1].split('&')[0].split('=')[1];
    String scriptFullscreen = "function launchIntoFullscreen(element) {"
        "   if(element.requestFullscreen) {"
        "      element.requestFullscreen(); }"
        "   else if(element.mozRequestFullScreen) {"
        "      element.mozRequestFullScreen();"
        "   } else if(element.webkitRequestFullscreen) "
        "      element.webkitRequestFullscreen();"
        "   } else if(element.msRequestFullscreen) {"
        "      element.msRequestFullscreen();    }  }            "
        "function onPlayerStateChange(event) {"
        "    if (event.data == YT.PlayerState.PLAYING) {"
        "      launchIntoFullscreen('yt')    } }";
    String head =
        "<style>img{width:100%}#player {position: relative;padding-top: 56.25%;}iframe{ position: absolute; top: 0; left: 0;width: 100%;height: 100%;}</style><script src='https://www.youtube.com/iframe_api' async></script><script>var player;function onYouTubeIframeAPIReady() { player = new YT.Player('yt', {videoId: '" +
            ytid +
            "'});}</script>";
    String videobody = "<div id='player'><div id='yt'></div></div>";
    final replString = data.replaceAllMapped(video, (match) {
      return videobody;
    });
    newStrng = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
        head +
        "</head><body>" +
        replString.replaceAll("figure", "div") +
        "</body></html>";
  } else
    newStrng =
        "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><style>img{width:100%}</style></head><body>" +
            data.replaceAll("\"", "'").replaceAll("figure", "div") +
            "</body></html>";

  return newStrng;
}
String encydata(String token, String data) {
  String Akey = token.substring(0, 32);
  String iv = token.substring(32, 48);
  final encrypter = _encypt.Encrypter(_encypt.AES(_encypt.Key.fromUtf8(Akey),
      mode: _encypt.AESMode.cbc, padding: 'PKCS7'));
  return encrypter.encrypt(data, iv: _encypt.IV.fromUtf8(iv)).base64;
}
String decryptdata(String token, String data) {
  try {
    String Akey = token.substring(0, 32);
    String iv = token.substring(32, 48);
    final decrypter = _encypt.Encrypter(_encypt.AES(_encypt.Key.fromUtf8(Akey),
        mode: _encypt.AESMode.cbc, padding: 'PKCS7'));
    return decrypter.decrypt(
        _encypt.Encrypted.fromBase64(data), iv: _encypt.IV.fromUtf8(iv));
  }
  catch(e){
    return null;
  }
}

Database db;
CacheHelp cacheHelp;
void initCache() async {
  if(db==null)
    db=await SQlitHelp.getdb(await getDatabasesPath());
  if(cacheHelp==null)
    cacheHelp=new CacheHelp(db);
}

bool isDiaglogShowing;
void showLoading(BuildContext context) {
  isDiaglogShowing = true;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child:
                Container(
                  height: 150,
                  child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("處理中..."),
                  Padding(padding: EdgeInsets.all(20),),
                  SizedBox( width: 50,height: 50,child:CircularProgressIndicator())]),
          ),
        );
      }).then((_) => isDiaglogShowing = false);
}
Future<void> showMyDialog(BuildContext context,String text,bool isShowAction ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      if(isShowAction)
        return AlertDialog(
          title: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('確定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      else
        return AlertDialog(
          title: Text(text),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
    },
  );
}
Future<bool> comfrirm(BuildContext context,String text) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('確定'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
    },
  );
}
Future<Object> getId(BuildContext context,bool isOnlyUserData) async {
  if(GlobleValue.deviceId==null) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme
        .of(context)
        .platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      GlobleValue.deviceId =
          iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      GlobleValue.deviceId =
          androidDeviceInfo.androidId; // unique ID on Android
    }
  }
    Map<String, dynamic> data =
    await UserDataService().getUserId(GlobleValue.deviceId,isOnlyUserData);
    GlobleValue.message_publish=data["messagePublish"];
    if(data["result"].toString().compareTo("true")==0) {
      GlobleValue.userId = int.parse(data["userId"]);
      GlobleValue.token = data["token"];
      GlobleValue.userName = data["userName"];
      GlobleValue.Golds = data["golds"];
      GlobleValue.proxy = data["proxy"].toString().toLowerCase()=="true";
      return true;
    }
    else{
      return data["result"].toString();
    }
  }
  Widget FadinHelp(TickerProvider provider,Widget widget){
    final fadincontroller=AnimationController(vsync:provider,duration:Duration(milliseconds: 300) );
    final fadinanimation=Tween(begin: 0.0,end: 1.0).animate(fadincontroller);
    fadincontroller.forward();
  return  FadeTransition(opacity: fadinanimation,child:widget);
  }
Future<void> ShowQRcodeImage( BuildContext context,QrImage qrImage) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content:SizedBox(height: 250,child: Center(child:qrImage)),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}