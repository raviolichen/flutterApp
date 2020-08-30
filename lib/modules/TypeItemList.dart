import 'package:zhushanApp/modules/TypeItem.dart';
class TypeItemList{
  List<TypeItem> typeItemList= new List<TypeItem>();
  final String md5;
  TypeItemList({
    this.typeItemList,
    this.md5
  });

  factory TypeItemList.fromJson(List<dynamic> json){
    String _md5;
    if(json.last['md5']!=null) {
      _md5 = json.last['md5'];
      json.removeLast();
    }
    List<TypeItem> typeItemList= new List<TypeItem>();
    typeItemList = json.map((i) => TypeItem.fromJson(i)).toList();
    return new TypeItemList(typeItemList:typeItemList,md5: _md5);
  }
}
