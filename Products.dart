class Product {
  int id = 0;
  String? title = "", description = "", image = "", itemtype = "";
  double price = 0;
  bool isSale;
  double? oldPrice;

  Product(
      {this.id = 0,
      this.title,
      this.description,
      this.image,
      this.price = 0,
      this.itemtype,
      this.oldPrice,
      required this.isSale});

  factory Product.fromFireBase(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;

    return Product(
      id: int.tryParse(fields['id']?['integerValue']?.toString() ?? '0') ?? 0,
      title: fields['title']?['stringValue'] ?? '',
      description: fields['description']?['stringValue'] ?? '',
      image: fields['image']?['stringValue'] ?? '',
      price: double.tryParse(fields['price']?['doubleValue']?.toString() ??
              fields['price']?['integerValue']?.toString() ??
              '0') ??
          0.0,
      oldPrice: double.tryParse(
              fields['oldPrice']?['doubleValue']?.toString() ??
                  fields['oldPrice']?['integerValue']?.toString() ??
                  '0') ??
          0.0,
      itemtype: fields['itemtype']?['stringValue'] ?? '',
      isSale: fields['isSale']?['booleanValue'] ?? false,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "fields": {
        "id": {"integerValue": id},
        "title": {"stringValue": title},
        "description": {"stringValue": description},
        "image": {"stringValue": image},
        "price": {"doubleValue": price},
        "oldPrice": {"doubleValue": oldPrice},
        "itemtype": {"stringValue": itemtype},
        "isSale": {"booleanValue": isSale},
      }
    };
  }
}

//-------------------
List<Product> products = [];
