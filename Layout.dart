import 'package:appbanhang/ListProducts_AdminFB.dart';
import 'package:appbanhang/models/Cart.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'ListSanpham.dart';
import 'CartScreen.dart';
import 'UserProfileBubble.dart';

class Layout extends StatefulWidget {
  final String email; // nhận email từ LoginScreen

  const Layout({Key? key, required this.email}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final List<Widget> _pages = [];
  @override
  void initState() {
    super.initState();
    _pages.addAll([
      Home(),
      ListSanpham(email: widget.email), // truyền email vào đây
      CartScreen(),
    ]);
  }

  int trangduocchon = 0;
  bool showUserBubble = false;

  void ChonTrang(int index) {
    setState(() {
      trangduocchon = index;
      showUserBubble = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.flutter_dash, size: 40, color: Colors.blue.shade700),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "TECHNOLOGY SHOP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  fontFamily: 'VnHelvetInsH',
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: () {
              setState(() {
                showUserBubble = !showUserBubble;
              });
            },
          ),
        ],
        elevation: 8,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade300.withOpacity(0.8),
                Colors.blue.shade600
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade300.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        toolbarHeight: 70,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        currentIndex: trangduocchon,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        onTap: ChonTrang,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      body: Stack(
        children: [
          _pages[trangduocchon],
          if (showUserBubble)
            UserProfileBubble(
              email: widget.email,
              onClose: () => setState(() => showUserBubble = false),
            ),
        ],
      ),
    );
  }
}
