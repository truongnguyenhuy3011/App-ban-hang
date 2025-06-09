import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/Products.dart';
import 'ProductCard.dart';

class Itemsale extends StatefulWidget {
  final Function(Product)? onAddToCartNotification;

  Itemsale({this.onAddToCartNotification});

  @override
  State<StatefulWidget> createState() {
    return Trangthai_Itemsale();
  }
}

class Trangthai_Itemsale extends State<Itemsale> {
  late Future<List<Product>> lstproducts;

  Future<List<Product>> fetchProductsFromFirebase() async {
    final url =
        'https://firestore.googleapis.com/v1/projects/mobile1-2e6b1/databases/(default)/documents/SAN%20PHAM';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> documents = jsonResponse['documents'] ?? [];

      // Chuyển đổi dữ liệu và lọc sản phẩm đang giảm giá
      return documents
          .map((doc) => Product.fromFireBase(doc))
          .where((product) => product.isSale == true)
          .toList();
    } else {
      throw Exception('Không thể tải sản phẩm từ Firebase');
    }
  }

  @override
  void initState() {
    super.initState();
    lstproducts = fetchProductsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: lstproducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có sản phẩm khuyến mãi'));
        } else {
          List<Product> lst = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(5),
            shrinkWrap: true, // <-- Thêm dòng này
            physics: NeverScrollableScrollPhysics(), // <-- Thêm dòng này
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.7,
            ),
            itemCount: lst.length,
            itemBuilder: (context, index) {
              Product product = lst[index];
              return ProductCard(
                product: product,
                onAddToCart: () {
                  widget.onAddToCartNotification?.call(product);
                },
              );
            },
          );
        }
      },
    );
  }
}
