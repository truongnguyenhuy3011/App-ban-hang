import 'package:flutter/material.dart';
import 'ListProducts_AdminFB.dart'; // import màn hình quản lý sản phẩm admin
import 'LoginScreen.dart';

class UserProfileBubble extends StatelessWidget {
  final String email;
  final VoidCallback onClose;

  const UserProfileBubble({
    Key? key,
    required this.email,
    required this.onClose,
  }) : super(key: key);

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 85,
      right: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 220,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle, size: 40, color: Colors.blue),
              SizedBox(height: 10),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),

              // Chỉ hiển thị nếu là admin
              if (email == 'admin@gmail.com')
                ListTile(
                  leading: Icon(Icons.inventory_2, color: Colors.blue),
                  title: Text(
                    "Sản phẩm Admin",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListProducts_AdminFB(),
                      ),
                    );
                    onClose(); // Đóng bubble sau khi mở trang mới
                  },
                ),

              ElevatedButton.icon(
                onPressed: () => logout(context),
                icon: Icon(Icons.logout),
                label: Text("Đăng xuất"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: Size(double.infinity, 36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
