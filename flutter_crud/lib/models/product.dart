class Product {
  int _id;
  String _item_code;
  String _item_name;
  String _price;
  String _stock;

  Product(this._item_code, this._item_name, this._price, this._stock);

  Product.map(dynamic obj) {
    this._id = obj['id'];
    this._item_code = obj['item_code'];
    this._item_name = obj['item_name'];
    this._price = obj['price'];
    this._stock = obj['stock'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["item_code"] = _item_code;
    map["item_name"] = _item_name;
    map["price"] = _price;
    map["stock"] = _stock;

    if (_id != null) {
      map["id"] = _id;
    }
  }

  Product.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._item_code = map['item_code'];
    this._item_name = map['item_name'];
    this._price = map['price'];
    this._stock = map['stock'];
  }
}
