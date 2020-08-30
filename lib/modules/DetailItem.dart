class DetailItem {
  List<String> potos;
  String html;
  String url;
  String LastEditDateTime;
  DetailItem({
    this.potos,
    this.html,
    this.url,
    this.LastEditDateTime
  });

  factory DetailItem.fromJson(List<dynamic> json) {
    return new DetailItem(
        potos:json.first['potos'].cast<String>(),
        html: json.first['html'],
        url: json.first['url'],
        LastEditDateTime: json.first['LastEditDateTime']
    );
  }
}