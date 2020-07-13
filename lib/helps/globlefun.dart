import 'package:device_info/device_info.dart';
import 'package:encrypt/encrypt.dart' as _encypt;
import 'package:flutter/material.dart';
import '../DataService.dart';
import 'GlobleValue.dart';
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
bool isDiaglogShowing;
void showLoading(BuildContext context) {
  isDiaglogShowing = true;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new SizedBox(
            width: 100,height: 100,
            child: AspectRatio(  aspectRatio: 1, child:new CircularProgressIndicator()),
          ),
        );
      }).then((_) => isDiaglogShowing = false);
}
Future<bool> getId(BuildContext context) async {
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
    await UserDataService().getUserId(GlobleValue.deviceId);
    if(data["result"].toString().compareTo("true")==0) {
      GlobleValue.userId = int.parse(data["userId"]);
      GlobleValue.token = data["token"];
      GlobleValue.userName = data["userName"];
      GlobleValue.Golds = data["golds"];
      return true;
    }
    else
      return false;
  }
