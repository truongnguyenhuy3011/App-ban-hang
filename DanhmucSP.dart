import 'package:flutter/material.dart';
import 'models/Products.dart';
import 'DanhmucScreen.dart'; // Đảm bảo rằng bạn có một trang DanhmucScreen để hiển thị sản phẩm theo danh mục

class DanhmucSP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Trangthai_DanhmucSP();
  }
}

class Trangthai_DanhmucSP extends State<DanhmucSP> {
  List<Product> lstproducts = products; // Dữ liệu sản phẩm lấy từ 'products'

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Danh mục "Điện thoại"
          InkWell(
            onTap: () => navigateToDanhmuc(context, "Mobilephone"),
            child: categoryContainer("Điện Thoại",
                "https://bachlongstore.vn/vnt_upload/product/09_2024/8447141_Apple_iPhone_16_Pro_finish_lineup_240909.png"),
          ),
          // Danh mục "Máy tính bảng"
          InkWell(
            onTap: () => navigateToDanhmuc(context, "Ipad"),
            child: categoryContainer("Máy Tính Bảng",
                "https://th.bing.com/th/id/R.653b0b8dd9a2abcdd59e33c609caf4f3?rik=X0TQDMhNbJzcgQ&pid=ImgRaw&r=0"),
          ),
          // Danh mục "Laptop"
          InkWell(
            onTap: () => navigateToDanhmuc(context, "Laptop"),
            child: categoryContainer("Laptop",
                "https://th.bing.com/th/id/R.7b289f43aad1664de8bb9258c8719f24?rik=p%2f7QBN19PS2mzQ&pid=ImgRaw&r=0"),
          ),
          // Danh mục "Phụ kiện"
          InkWell(
            onTap: () => navigateToDanhmuc(context, "PhuKien"),
            child: categoryContainer("Phụ Kiện",
                "https://phukiengiaxuong.com.vn/cdn3/images/cap-sac-anker-lightning-poweline-ii-a8452.jpg"),
          ),
          // Danh mục "Thiết bị lưu trữ"
          InkWell(
            onTap: () => navigateToDanhmuc(context, "Archive"),
            child: categoryContainer("Thiết Bị Lưu Trữ",
                "https://th.bing.com/th/id/OIP.hGM03Dj4xfByyKDGEuMYjAHaHa?rs=1&pid=ImgDetMain"),
          ),
        ],
      ),
    );
  }

  Widget categoryContainer(String title, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(imageUrl, width: 40, height: 40),
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

void navigateToDanhmuc(BuildContext context, String type) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DanhmucScreen(
        lstproducts: null,
        categoryTitle: CategoryTitle(type),
        categoryImage: CategoryImage(type),
        itemtype: type, // <-- thêm dòng này
      ),
    ),
  );
}

String CategoryTitle(String type) {
  switch (type) {
    case "Mobilephone":
      return "Điện Thoại";
    case "Ipad":
      return "Máy Tính Bảng";
    case "Laptop":
      return "Laptop";
    case "PhuKien":
      return "Phụ Kiện";
    case "Archive":
      return "Thiết Bị Lưu Trữ";
    default:
      return "ERROR";
  }
}

String CategoryImage(String type) {
  switch (type) {
    case "Mobilephone":
      return "https://bachlongstore.vn/vnt_upload/product/09_2024/8447141_Apple_iPhone_16_Pro_finish_lineup_240909.png";
    case "Ipad":
      return "https://th.bing.com/th/id/R.653b0b8dd9a2abcdd59e33c609caf4f3?rik=X0TQDMhNbJzcgQ&pid=ImgRaw&r=0";
    case "Laptop":
      return "https://th.bing.com/th/id/R.7b289f43aad1664de8bb9258c8719f24?rik=p%2f7QBN19PS2mzQ&pid=ImgRaw&r=0";
    case "PhuKien":
      return "https://phukiengiaxuong.com.vn/cdn3/images/cap-sac-anker-lightning-poweline-ii-a8452.jpg";
    case "Archive":
      return "https://th.bing.com/th/id/OIP.hGM03Dj4xfByyKDGEuMYjAHaHa?rs=1&pid=ImgDetMain";
    default:
      return "ERROR";
  }
}
