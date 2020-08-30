import 'Record.dart';
class RecordList {
  List<Record> records = new List();
  String md5;
  RecordList({
    this.records,
    this.md5
  });

  factory RecordList.fromJson(List<dynamic> parsedJson) {
    String _md5;
    if(parsedJson.length>0&&parsedJson.last['md5']!=null) {
      _md5 = parsedJson.last['md5'];
      parsedJson.removeLast();
    }
    List<Record> records = new List<Record>();
    records = parsedJson.map((i) => Record.fromJson(i)).toList();
    return new RecordList(
      records: records,md5: _md5
    );
  }
}
