import 'package:zhushanApp/modules/CacheDataModules.dart';

class Record {
  String id;
  String title;
  String subtext;
  String data;
  String photo;
  String url;

  Record({
    this.id,
    this.title,
    this.subtext,
    this.data,
    this.photo,
    this.url
  });

  factory Record.fromJson(Map<String, dynamic> json){
    try{
      return new Record(
          id: json['id'],
          title: json['title'],
          subtext: json['subtext'],
          data: json ['data'],
          photo: json['photo'],
          url: json['url']
      );
    }
    catch(ex){
      return null;
    }
  }
}