import 'package:zhushanApp/modules/EventItem.dart';
class HomePageData{
  List<String> banner;
 List<EventItem> eventList= new List<EventItem>();
  HomePageData({
    this.banner,this.eventList
  });

  factory HomePageData.fromJson(List<dynamic> json){

    List<String>banners= new List<String>();
    banners = json[0]['Banner'].cast<String>();
    List<EventItem> eventItems= new List<EventItem>();
    List<dynamic> e=json[0]["EventList"];
    eventItems = e.map((i) => EventItem.fromJson(i)).toList();
    return new HomePageData(banner:banners,eventList: eventItems);
  }
}
