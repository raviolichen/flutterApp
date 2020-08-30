import 'package:zhushanApp/modules/EventItem.dart';
class HomePageData{
  List<String> banner;
  List<EventItem> eventList= new List<EventItem>();
  String md5;
  HomePageData({
    this.banner,this.eventList,this.md5
  });

  factory HomePageData.fromJson(List<dynamic> json){
    List<String>banners= new List<String>();
    banners = json[0]['Banner'].cast<String>();
    List<EventItem> eventItems= new List<EventItem>();
    List<dynamic> e=json[0]["EventList"];
    eventItems = e.map((i) => EventItem.fromJson(i)).toList();
    return new HomePageData(banner:banners,eventList: eventItems,md5: json[0]['md5']);
  }
}
