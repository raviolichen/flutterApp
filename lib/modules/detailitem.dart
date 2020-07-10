class DetailItem {
  List<String> potos;
  String html;
  String url;

  DetailItem({
    this.potos,
    this.html,
    this.url,
  });

  factory DetailItem.fromJson(List<dynamic> json) {
    return new DetailItem(
        potos:json.first['potos'].cast<String>(),
        html: json.first['html'],
        url: json.first['url']
    );
  }
}