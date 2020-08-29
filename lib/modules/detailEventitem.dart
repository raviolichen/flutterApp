class DetailEventItem {
  String eventType;
  String ButtonText;
  String ButtonEnable;
  String detail;
  String voteButtonEnable;
  String voteButtonText;
  String vId;
  String vtype;
  int votecount;
  String LastEditDateTime;

  DetailEventItem({
    this.eventType,
    this.ButtonText,
    this.ButtonEnable,
    this.detail,
    this.voteButtonEnable,
    this.voteButtonText,
    this.vId,
    this.vtype,
    this.votecount,
    this.LastEditDateTime
  });

  factory DetailEventItem.fromJson(List<dynamic> json) {
    return new DetailEventItem(
      eventType:json.first['eventType'],
      ButtonText: json.first['ButtonText'],
      ButtonEnable: json.first['ButtonEnable'],
      detail: json.first['detail'],
      voteButtonText: json.first['VoteButtonText'],
      voteButtonEnable: json.first['VoteButtonEnable'],
      vId: json.first['vId'],
      vtype: json.first['vtype'],
        votecount:json.first['votecount'],
      LastEditDateTime:json.first['LastEditDateTime'],
    );
  }
}