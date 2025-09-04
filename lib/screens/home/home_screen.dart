import 'package:app_flutter/screens/product/product_list_screen.dart';
import 'package:app_flutter/services/product_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/services/auth_services.dart';
import 'package:app_flutter/screens/order/order_history_screen.dart';
import 'package:app_flutter/screens/profile/profile_screen.dart';
import 'package:app_flutter/screens/cart/cart_screen.dart';
import 'package:app_flutter/models/product_model.dart';
import 'package:app_flutter/screens/product/product_card.dart';
import 'package:app_flutter/screens/product/search_Screen.dart';
import 'package:app_flutter/core/widgets/app_bar.dart';
import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authServices = AuthServices();
  final productServices = ProductServices();
  int _selectedIndex = 0;

  static List<String> _appBarTitles = <String>[
    'Trang chủ',
    'Danh sách sản phẩm',
    'Lịch sử đơn hàng',
    'Tài khoản',
  ];
  // danh sách các màn hình
  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    ProductListScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];
  // hàm xử lý khi một tab được nhấn
  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTapAppBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth
        .instance
        .currentUser; // truy cập vào firebaseAuht lấy thông tin người dùng hiện tại
    final authServices = AuthServices();
    bool isHomeScreen = _selectedIndex == 0;
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitles[_selectedIndex],
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        leading: isHomeScreen
            ? null
            : IconButton(
                onPressed: () {
                  _onTapAppBar(0);
                },
                icon: Icon(Icons.arrow_back),
              ),
        actions: [
          IconButton(
            onPressed: () {
              _onTapAppBar(3);
            },
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'Tài khoản',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CartScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            tooltip: 'Giỏ hàng',
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchScreen());
            },
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'Tìm kiếm',
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        // backgroundColor: const Color.fromARGB(255, 1, 20, 49),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 1, 20, 49),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Về Chúng Tôi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {}, // điều hướng đến trang về chúng tôi
            ),
            // const SizedBox(height: 10),
            ListTile(
              title: const Text(
                'Sản Phẩm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onTapAppBar(1);
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử đơn hàng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onTap,
      ),
    );
  }
}
