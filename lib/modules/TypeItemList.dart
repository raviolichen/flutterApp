
import 'package:zhushanApp/modules/TypeItem.dart';

class TypeItemList{
  List<TypeItem> typeItemList= new List<TypeItem>();
  TypeItemList({
    this.typeItemList
  });

  factory TypeItemList.fromJson(List<dynamic> json){
    List<TypeItem> typeItemList= new List<TypeItem>();
    typeItemList = json.map((i) => TypeItem.fromJson(i)).toList();
    return new TypeItemList(typeItemList:typeItemList);
  }
}
