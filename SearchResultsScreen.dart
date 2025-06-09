import 'package:flutter/material.dart';
import 'DanhmucScreen.dart';
import 'models/Products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchResultsScreen extends StatelessWidget {
  final String searchKeyword;

  SearchResultsScreen({required this.searchKeyword});

  Future<List<Product>> fetchAllProductsFromFirebase() async {
    final url =
        'https://firestore.googleapis.com/v1/projects/mobile1-2e6b1/databases/(default)/documents/SAN%20PHAM';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> documents = jsonResponse['documents'] ?? [];

      List<Product> allProducts =
          documents.map((doc) => Product.fromFireBase(doc)).toList();

      return allProducts;
    } else {
      throw Exception('Không thể tải sản phẩm từ Firebase');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchAllProductsFromFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Lỗi: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          List<Product> allProducts = snapshot.data!;

          // Lọc sản phẩm theo từ khóa tìm kiếm, không phân biệt hoa thường
          List<Product> filteredList = allProducts.where((product) {
            return product.title != null &&
                product.title!
                    .toLowerCase()
                    .contains(searchKeyword.toLowerCase());
          }).toList();

          return DanhmucScreen(
            lstproducts: filteredList,
            itemtype: "",
            categoryTitle: 'Kết quả cho: "$searchKeyword"',
            categoryImage:
                "https://cdn-icons-png.flaticon.com/512/2811/2811790.png",
          );
        } else {
          return Scaffold(
            body: Center(child: Text('Không có dữ liệu')),
          );
        }
      },
    );
  }
}
