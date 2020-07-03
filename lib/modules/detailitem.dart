class DetailItem {
  String eventType;
  String ButtonText;
  String ButtonEnable;
  String detail;

  DetailItem({
    this.eventType,
    this.ButtonText,
    this.ButtonEnable,
    this.detail,
  });

  factory DetailItem.fromJson(List<dynamic> json) {
    return new DetailItem(
      eventType:json.first['eventType'],
      ButtonText: json.first['ButtonText'],
      ButtonEnable: json.first['ButtonEnable'],
      detail: json.first['detail'],
    );
  }
}