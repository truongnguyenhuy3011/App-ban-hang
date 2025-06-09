import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/Products.dart';
import 'ProductCard.dart';

class DanhmucScreen extends StatelessWidget {
  final List<Product>? lstproducts;
  final String categoryImage;
  final String categoryTitle;
  final String itemtype;

  DanhmucScreen({
    this.lstproducts,
    required this.categoryImage,
    required this.categoryTitle,
    required this.itemtype,
  });

  Future<List<Product>> fetchProducts() async {
    final url =
        'https://firestore.googleapis.com/v1/projects/mobile1-2e6b1/databases/(default)/documents/SAN%20PHAM?key=AIzaSyBAKqiA3sGXdpqtPdfbi7qL3RIqTwOs2os';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> documents = jsonResponse['documents'] ?? [];

      return documents
          .map((item) => Product.fromFireBase(item))
          .where((product) => product.itemtype == itemtype)
          .toList();
    } else {
      throw Exception('Không thể tải sản phẩm từ Firebase');
    }
  }

  Widget buildProductList(List<Product> products, BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(categoryImage, width: 40, height: 40),
                  SizedBox(width: 10),
                  Text(
                    categoryTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(6),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.flutter_dash, size: 50),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "TECHNOLOGY SHOP",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'VnHelvetInsH',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        shadowColor: Colors.grey.withOpacity(0.4),
        toolbarHeight: 80,
        backgroundColor: Colors.grey.withOpacity(0.15),
      ),
      body: lstproducts != null
          ? buildProductList(lstproducts!, context)
          : FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có dữ liệu nào'));
                } else {
                  return buildProductList(snapshot.data!, context);
                }
              },
            ),
    );
  }
}
