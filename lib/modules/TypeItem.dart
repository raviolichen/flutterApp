class TypeItem{
  final String TId;
  final String TName;
  final List<String> Images;

  TypeItem({this.TId, this.Images, this.TName});

  @override
  factory TypeItem.fromJson(Map<String, dynamic> json){
    return new TypeItem(
      TId: json['TId'],
      TName: json['TName'],
      Images: json['Images'].cast<String>()
    );
  }
}