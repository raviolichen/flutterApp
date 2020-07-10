class DetailEventItem {
  String eventType;
  String ButtonText;
  String ButtonEnable;
  String detail;

  DetailEventItem({
    this.eventType,
    this.ButtonText,
    this.ButtonEnable,
    this.detail,
  });

  factory DetailEventItem.fromJson(List<dynamic> json) {
    return new DetailEventItem(
      eventType:json.first['eventType'],
      ButtonText: json.first['ButtonText'],
      ButtonEnable: json.first['ButtonEnable'],
      detail: json.first['detail'],
    );
  }
}