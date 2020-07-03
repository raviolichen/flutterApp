class EventItem {
  int eId;
  String url;
  String title;
  String date;
  String text;

  EventItem({
    this.eId,
    this.url,
    this.title,
    this.date,
    this.text
  });

  factory EventItem.fromJson(Map<String, dynamic> json){
    if(json!=null)
    return new EventItem(
        eId: json['EId'],
        url: json['url'],
        title: json ['title'],
        date: json['date'],
        text: json['text']
    );
    else
      return null;
  }
}