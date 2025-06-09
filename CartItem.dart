import 'Products.dart';

class CartItem {
  Product product;
  int soluong;
  double? current_price = 0;
  double? ratio_sale_off = 0;

  CartItem(
      {required this.soluong,
      required this.product,
      current_price = 0,
      ratio_sale_off = 0});
}
