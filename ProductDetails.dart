import 'package:flutter/material.dart';
import 'models/Products.dart';
import 'CartScreen.dart';
import 'models/Cart.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetails> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Chi tiết sản phẩm'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFavorited = !isFavorited;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorited
                      ? 'Đã thêm vào yêu thích'
                      : 'Đã xóa khỏi yêu thích'),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hình ảnh
            Image.network(
              product.image ?? '',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (product.isSale && product.oldPrice != null)
                    Row(
                      children: [
                        Text(
                          "\$${product.oldPrice} ",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "\$${product.price} ",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    )
                  else
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Mô tả sản phẩm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description ?? 'Mô tả sản phẩm không có sẵn.',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ElevatedButton.icon(
          onPressed: () {
            Cart.addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${product.title} đã được thêm vào giỏ hàng'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: "Xem giỏ hàng",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartScreen(),
                      ));
                },
              ),
            ));
          },
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Thêm vào giỏ hàng'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
