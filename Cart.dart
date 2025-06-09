import 'Products.dart';
import 'CartItem.dart';

class Cart {
  static List<CartItem> giohang = [];

  static void addToCart(Product product) {
    int index = giohang.indexWhere((yy) => yy.product.id == product.id);

    if (index != -1) /*Da co trong gio */
    {
      giohang[index].soluong++;
    } else {
      giohang.add(CartItem(product: product, soluong: 1));
    }
  }

  static void removeFromCart(int productID) {
    int index = giohang.indexWhere((xx) => xx.product.id == productID);
    if (index != -1) {
      giohang.remove(giohang[index]);
    }
  }

  static double Tongtien() {
    double total = 0;
    for (var p in giohang) {
      total += p.product.price * p.soluong;
    }
    return total;
  }
}
