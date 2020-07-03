class DetailListItem {
  String storeHtml;
  String StoreWeb;
  String storeWebF;
  String stroeMapLocation;
  List<String> potos;
  List<storeProduct> products;

  DetailListItem({
    this.storeHtml,
    this .StoreWeb,
    this .storeWebF,
    this. stroeMapLocation,
    this.potos,
    this. products

  });

  factory DetailListItem.fromJson(List<dynamic> json) {

    List<String> _potos= json.first['images'].cast<String>();
    List<dynamic> e=json.first["storeProductList"];
    List<storeProduct> _products=e.map((i)=>storeProduct.fromJson(i)).toList();

    return new DetailListItem(
      storeHtml: json.first['storeHtml'],
      StoreWeb: json.first['StoreWeb'],
      storeWebF: json.first['storeWebF'],
      stroeMapLocation: json.first['stroeMapLocation'],
      potos:_potos,
      products: _products,
    );
  }
}

class storeProduct {
  String pName;
  String pText;
  String pImage;

  storeProduct({
    this.pName,
    this.pText,
    this.pImage
  });

  factory storeProduct.fromJson(Map<String,dynamic> json) {
    return new storeProduct(
      pName: json['pName'],
      pText: json['pText'],
      pImage: json['pImage']
    );
  }
}