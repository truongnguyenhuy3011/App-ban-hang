import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/Products.dart';
import 'models/NotificationItem.dart';
import 'models/SearchTelex.dart';
import 'ProductCard.dart';
import 'AddProductFB.dart';

enum SortOption { none, priceLowToHigh, priceHighToLow }

class ListSanpham extends StatefulWidget {
  final String email;
  const ListSanpham({Key? key, required this.email}) : super(key: key);
  @override
  State<ListSanpham> createState() => _ListSanphamState();
}

class _ListSanphamState extends State<ListSanpham> {
  List<Product> lstproducts = [];
  List<Product> allProducts = [];
  List<NotificationItem> notifications = [];
  TextEditingController txttimkiem = TextEditingController();
  SortOption sortOption = SortOption.none;

  @override
  void initState() {
    super.initState();
    fetchProductsFromFirebase();
  }

  Future<void> fetchProductsFromFirebase() async {
    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/mobile1-2e6b1/databases/(default)/documents/SAN%20PHAM?key=AIzaSyBAKqiA3sGXdpqtPdfbi7qL3RIqTwOs2os'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<Product> fetched = (jsonResponse['documents'] ?? [])
          .map<Product>((item) => Product.fromFireBase(item))
          .toList();
      setState(() {
        lstproducts = fetched;
        allProducts = fetched;
      });
    }
  }

  void timKiemSanPham(String query) {
    final normalizedSearch = SearchTelex.removeDiacritics(query.toLowerCase());
    setState(() {
      lstproducts = allProducts.where((product) {
        final normalizedTitle =
            SearchTelex.removeDiacritics(product.title?.toLowerCase() ?? '');
        return normalizedTitle.contains(normalizedSearch);
      }).toList();
      // Sau khi tìm kiếm, áp dụng lại sắp xếp nếu có
      if (sortOption != SortOption.none) {
        _sortProducts(sortOption);
      }
    });
  }

  void _sortProducts(SortOption option) {
    setState(() {
      sortOption = option;
      if (option == SortOption.priceLowToHigh) {
        lstproducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
      } else if (option == SortOption.priceHighToLow) {
        lstproducts.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
      } else {
        // Mặc định: lấy lại từ allProducts và áp dụng tìm kiếm lại
        lstproducts = allProducts.where((product) {
          final normalizedTitle =
              SearchTelex.removeDiacritics(product.title?.toLowerCase() ?? '');
          final normalizedSearch =
              SearchTelex.removeDiacritics(txttimkiem.text.toLowerCase());
          return normalizedTitle.contains(normalizedSearch);
        }).toList();
      }
    });
  }

  void addNotification(Product product) {
    setState(() {
      notifications.add(NotificationItem(
        message: product.title!,
        imageUrl: product.image!,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "DANH SÁCH SẢN PHẨM",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_outlined,
                    color: Colors.black87),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Thông báo"),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: notifications.isEmpty
                            ? Center(child: Text("Chưa có thông báo nào"))
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: notifications.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final notif = notifications[index];
                                  return ListTile(
                                    leading: Image.network(
                                      notif.imageUrl,
                                      width: 50,
                                      height: 50,
                                      errorBuilder: (_, __, ___) =>
                                          Icon(Icons.broken_image),
                                    ),
                                    title: Text(notif.message,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  );
                                },
                              ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Đóng"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (notifications.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${notifications.length}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: lstproducts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    controller: txttimkiem,
                    onChanged: timKiemSanPham,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 4, 16, 8), // giảm khoảng cách trên xuống 4
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Sắp xếp: ",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      SizedBox(width: 4),
                      DropdownButton<SortOption>(
                        value: sortOption,
                        underline: SizedBox(),
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                        onChanged: (SortOption? newValue) {
                          if (newValue != null) {
                            _sortProducts(newValue);
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: SortOption.none,
                            child: Text("Mặc định"),
                          ),
                          DropdownMenuItem(
                            value: SortOption.priceLowToHigh,
                            child: Text("Giá tăng dần"),
                          ),
                          DropdownMenuItem(
                            value: SortOption.priceHighToLow,
                            child: Text("Giá giảm dần"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      itemCount: lstproducts.length,
                      padding: EdgeInsets.only(bottom: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final product = lstproducts[index];
                        return ProductCard(
                          product: product,
                          onAddToCart: () => addNotification(product),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: widget.email == 'admin@gmail.com'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductFB()),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.add),
              tooltip: 'Thêm sản phẩm',
            )
          : null,
    );
  }
}
