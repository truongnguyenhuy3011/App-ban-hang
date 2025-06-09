import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Products.dart';
import 'ProductEditFB.dart';
import 'AddProductFB.dart';

class ListProducts_AdminFB extends StatefulWidget {
  const ListProducts_AdminFB({super.key});

  @override
  State<ListProducts_AdminFB> createState() => _ListProducts_AdminFBState();
}

class _ListProducts_AdminFBState extends State<ListProducts_AdminFB> {
  List<Product> productList = [];
  List<String> docIds = [];

  final String baseUrl =
      'https://firestore.googleapis.com/v1/projects/mobile1-2e6b1/databases/(default)/documents/SAN%20PHAM?key=AIzaSyBAKqiA3sGXdpqtPdfbi7qL3RIqTwOs2os';
  final String apiKey = "AIzaSyBAKqiA3sGXdpqtPdfbi7qL3RIqTwOs2os";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse("$baseUrl?key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final documents = data['documents'] as List<dynamic>;

      final loadedProducts = <Product>[];
      final loadedDocIds = <String>[];

      for (var doc in documents) {
        final fields = doc['fields'] as Map<String, dynamic>;
        final name = doc['name'] as String;
        final docId = name.split('/').last;

        loadedProducts.add(Product.fromFireBase({'fields': fields}));
        loadedDocIds.add(docId);
      }

      setState(() {
        productList = loadedProducts;
        docIds = loadedDocIds;
      });
    } else {
      print(
          "❌ Lỗi khi tải sản phẩm: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> deleteProduct(int index) async {
    final docId = docIds[index];
    final url = Uri.parse("$baseUrl/$docId?key=$apiKey");

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        productList.removeAt(index);
        docIds.removeAt(index);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("🗑️ Đã xóa sản phẩm")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Lỗi xóa sản phẩm: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách sản phẩm",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: productList.isEmpty
          ? Center(child: CircularProgressIndicator()) // Chờ tải dữ liệu
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image ?? "",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title ?? "",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Giá: ${product.price}đ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    product.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductEditFB(
                                          product: product,
                                          docId: docIds[index],
                                        ),
                                      ),
                                    );
                                    fetchProducts(); // Tải lại sau khi chỉnh sửa
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => deleteProduct(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductFB(),
            ),
          );
          fetchProducts(); // Tải lại danh sách sau khi thêm
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }
}
