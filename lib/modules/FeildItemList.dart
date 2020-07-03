import 'FeildItem.dart';
class FeildItemList {
  List<FeildItem> fitems = new List();
  FeildItemList({
    this.fitems
  });

  factory FeildItemList.fromJson(List<dynamic> parsedJson) {
    List<FeildItem> fitems = new List<FeildItem>();
    fitems = parsedJson.map((i) => FeildItem.fromJson(i)).toList();
    return new FeildItemList(
      fitems: fitems,
    );
  }
}
