import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Products.dart';

class AddProductFB extends StatefulWidget {
  const AddProductFB({super.key});

  @override
  State<AddProductFB> createState() => _AddProductFBState();
}

class _AddProductFBState extends State<AddProductFB> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _oldPriceController = TextEditingController();
  final _itemtypeController = TextEditingController();

  bool isSale = false;

  final String baseUrl =
      'https://firestore.googleapis.com/v1/projects/mobile1-2e6b1/databases/(default)/documents/SAN%20PHAM?key=AIzaSyBAKqiA3sGXdpqtPdfbi7qL3RIqTwOs2os';
  final String apiKey = "AIzaSyBAKqiA3sGXdpqtPdfbi7qL3RIqTwOs2os";

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      image: _imageController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      oldPrice: double.tryParse(_oldPriceController.text) ?? 0,
      itemtype: _itemtypeController.text.trim(),
      isSale: isSale,
    );

    final response = await http.post(
      Uri.parse("$baseUrl?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toFirebase()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Đã thêm sản phẩm")),
      );
      Navigator.pop(context);
    } else {
      print("❌ Lỗi khi thêm sản phẩm: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Thêm sản phẩm thất bại: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("➕ Thêm sản phẩm"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF6F9FF),
        padding: const EdgeInsets.all(20),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  buildInputField(
                      controller: _titleController,
                      label: "Tên sản phẩm",
                      icon: Icons.shopping_bag,
                      validator: (value) => value == null || value.isEmpty
                          ? "Nhập tên sản phẩm"
                          : null),
                  buildInputField(
                      controller: _descriptionController,
                      label: "Mô tả",
                      icon: Icons.description),
                  buildInputField(
                      controller: _imageController,
                      label: "URL hình ảnh",
                      icon: Icons.image),
                  buildInputField(
                      controller: _priceController,
                      label: "Giá",
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number),
                  buildInputField(
                      controller: _oldPriceController,
                      label: "Giá gốc (nếu có)",
                      icon: Icons.money_off,
                      keyboardType: TextInputType.number),
                  buildInputField(
                      controller: _itemtypeController,
                      label: "Loại sản phẩm",
                      icon: Icons.category),
                  const SizedBox(height: 10),
                  SwitchListTile.adaptive(
                    title: const Text("Sản phẩm đang khuyến mãi"),
                    value: isSale,
                    onChanged: (val) {
                      setState(() {
                        isSale = val;
                      });
                    },
                    secondary: const Icon(Icons.local_offer),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: addProduct,
                    icon: const Icon(Icons.add),
                    label: const Text("Thêm sản phẩm"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
