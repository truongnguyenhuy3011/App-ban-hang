import 'package:flutter/material.dart';
import 'models/Products.dart'; // Đảm bảo bạn đã import model Product
import 'ProductDetails.dart';
import 'CartScreen.dart';
import 'models/Cart.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;

  const ProductCard({
    Key? key,
    this.onAddToCart,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ảnh sản phẩm và label giảm giá
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(product: product),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.network(
                      product.image ?? "",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  ),
                  if (product.isSale &&
                      product.oldPrice != null &&
                      product.oldPrice! > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'GIẢM ${((1 - (product.price / product.oldPrice!)) * 100).round()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Nội dung thông tin sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                // Tiêu đề sản phẩm
                Text(
                  product.title ?? "Sản phẩm không tên",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6),

                // Giá và icon giỏ hàng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hiển thị giá sản phẩm
                    product.isSale
                        ? Row(
                            children: [
                              Text(
                                "\$${product.oldPrice?.toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "\$${product.price.toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "\$${product.price.toStringAsFixed(1)}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                    // Nút giỏ hàng
                    IconButton(
                      icon: Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Cart.addToCart(product); // Thêm sản phẩm vào giỏ hàng
                        if (onAddToCart != null) {
                          onAddToCart!(); // Gửi callback về Home
                        }

                        // Hiển thị thông báo khi thêm vào giỏ hàng
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${product.title} đã được thêm vào giỏ hàng'),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: "Xem giỏ hàng",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CartScreen(),
                                ),
                              );
                            },
                          ),
                        ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
