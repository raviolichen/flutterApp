int i=0;
String htmlformat(String data) {
  String newStrng ="";
  RegExp video=RegExp(r'<oembed url="(.*)"><\/oembed>');
  Iterable <Match> matches = video.allMatches(data);
  if(matches!=null&&matches.length>0){
    String ytid=matches.elementAt(0).group(1).split('?')[1].split('=')[1];
    String scriptFullscreen=
        "function launchIntoFullscreen(element) {"
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
    String head="<style>img{width:100%}#player {position: relative;padding-top: 56.25%;}iframe{ position: absolute; top: 0; left: 0;width: 100%;height: 100%;}</style><script src='https://www.youtube.com/iframe_api' async></script><script>var player;function onYouTubeIframeAPIReady() { player = new YT.Player('yt', {videoId: '"+ytid+"'});}</script>";
    String videobody="<div id='player'><div id='yt'></div></div>";
    final replString = data.replaceAllMapped(video, (match) {
      return videobody;
    });
    newStrng ="<!DOCTYPE html><html><head>"+head+"</head><body>"+replString.replaceAll("figure","div")+"</body></html>";
  }
  else
    newStrng ="<!DOCTYPE html><html><head><style>img{width:100%}</style></head><body>"+data.replaceAll("\"","'").replaceAll("figure","div")+"</body></html>";

  return newStrng;
}