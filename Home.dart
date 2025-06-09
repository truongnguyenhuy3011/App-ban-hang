import 'package:appbanhang/DanhmucScreen.dart';
import 'package:flutter/material.dart';

import "DanhmucSP.dart";
import "Itemsale.dart";

import 'models/Products.dart';
import 'SearchResultsScreen.dart';
import 'models/NotificationItem.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> lstproducts = products;
  List<NotificationItem> notifications = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          _buildTopBar(context),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DrawerButton(onPressed: () => showCustomDrawer(context)),
              const SizedBox(width: 5),
              const Text('Menu'),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black,
                onPressed: () => _showSearchBottomSheet(context),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications, color: Colors.black),
                    if (notifications.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.red,
                          child: Text(
                            '${notifications.length}',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _showNotificationsDialog(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DANH MỤC SẢN PHẨM",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            DanhmucSP(),
            const SizedBox(height: 10),
            Text(
              "HOT SALE",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            Itemsale(
              onAddToCartNotification: (product) {
                setState(() {
                  notifications.add(
                    NotificationItem(
                      message: "Đã thêm ${product.title} vào giỏ hàng",
                      imageUrl: product.image ?? '',
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Nhập từ khóa tìm kiếm...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final search = _searchController.text.trim();
                  if (search.isNotEmpty) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SearchResultsScreen(searchKeyword: search),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Vui lòng nhập từ khóa tìm kiếm')),
                    );
                  }
                },
                child: const Text('Tìm kiếm'),
              )
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thông báo"),
        content: SizedBox(
          width: double.maxFinite,
          child: notifications.isEmpty
              ? const Center(child: Text("Chưa có thông báo nào"))
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final notif = notifications[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          notif.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(
                        notif.message,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          )
        ],
      ),
    );
  }
}

void showCustomDrawer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => const DrawerContent(),
  );
}

class DrawerContent extends StatelessWidget {
  const DrawerContent();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: ListView(
          children: [
            Container(
              height: 120,
              child: DrawerHeader(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://thongsokythuat.vn/wp-content/uploads/Dien-thoai-Apple-iPhone-14-Pro-Max-2022.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image, size: 60),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'SẢN PHẨM CÔNG NGHỆ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ..._drawerItems(context),
          ],
        ));
  }

  List<Widget> _drawerItems(BuildContext context) {
    final categories = {
      "Mobilephone": "Điện Thoại",
      "Ipad": "Máy Tính Bảng",
      "Laptop": "LapTop",
      "PhuKien": "Phụ Kiện",
      "Archive": "Thiết Bị Lưu Trữ",
    };

    final categoryImages = {
      "Mobilephone":
          "https://cdn1.katadata.co.id/media/images/thumb/2024/09/10/iPhone_16_Pro_Max-2024_09_10-06_59_46_7af9e8ffea95ab61a774e0c84a9455bc_960x640_thumb.jpg", // Thay link ảnh điện thoại
      "Ipad":
          "https://www.gizmochina.com/wp-content/uploads/2022/12/Ipad_pro_concept_hybrid_oled-scaled.jpeg", // Thay link ảnh máy tính bảng
      "Laptop":
          "https://th.bing.com/th/id/OIP.iDrfoKsPTUQhz5OCNG-MkgHaEn?rs=1&pid=ImgDetMain", // Thay link ảnh laptop
      "PhuKien":
          "https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tai-nghe-khong-day-soundpeats-air-4_8_.png", // Thay link ảnh phụ kiện
      "Archive":
          "https://th.bing.com/th/id/OIP.ufpuVPd-8zceuY4iGWJFrAHaFj?rs=1&pid=ImgDetMain", // Thay link ảnh thiết bị lưu trữ
    };

    return categories.entries.map((entry) {
      return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            categoryImages[entry.key] ?? '',
            width: 30,
            height: 30,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 30),
          ),
        ),
        title: Text(entry.value,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        onTap: () {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 50), () {
            navigateToDanhmuc(context, entry.key);
          });
        },
      );
    }).toList();
  }
}

void navigateToDanhmuc(BuildContext context, String type) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DanhmucScreen(
        lstproducts: null,
        categoryTitle: _categoryTitle(type),
        categoryImage: _categoryImage(type),
        itemtype: type,
      ),
    ),
  );
}

String _categoryTitle(String type) {
  return {
        "Mobilephone": "Điện Thoại",
        "Ipad": "Máy Tính Bảng",
        "Laptop": "LapTop",
        "PhuKien": "Phụ Kiện",
        "Archive": "Thiết Bị Lưu Trữ",
      }[type] ??
      "ERROR";
}

String _categoryImage(String type) {
  return {
        "Mobilephone":
            "https://bachlongstore.vn/vnt_upload/product/09_2024/8447141_Apple_iPhone_16_Pro_finish_lineup_240909.png",
        "Ipad":
            "https://th.bing.com/th/id/R.653b0b8dd9a2abcdd59e33c609caf4f3?rik=X0TQDMhNbJzcgQ&pid=ImgRaw&r=0",
        "Laptop":
            "https://th.bing.com/th/id/R.7b289f43aad1664de8bb9258c8719f24?rik=p%2f7QBN19PS2mzQ&pid=ImgRaw&r=0",
        "PhuKien":
            "https://phukiengiaxuong.com.vn/cdn3/images/cap-sac-anker-lightning-poweline-ii-a8452.jpg",
        "Archive":
            "https://th.bing.com/th/id/OIP.hGM03Dj4xfByyKDGEuMYjAHaHa?rs=1&pid=ImgDetMain",
      }[type] ??
      "ERROR";
}
