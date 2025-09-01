import 'package:app_flutter/screens/product/product_detail_screen.dart';
import 'package:app_flutter/screens/product/product_list_screen.dart';
import 'package:app_flutter/services/product_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/services/auth_services.dart';
import 'package:app_flutter/models/user_model.dart';
import 'package:app_flutter/screens/auth/auth_screen.dart';
import 'package:app_flutter/screens/order/order_history_screen.dart';
import 'package:app_flutter/screens/profile/profile_screen.dart';
import 'package:app_flutter/screens/product/product_list_screen.dart';
import 'package:app_flutter/screens/cart/cart_screen.dart';
import 'package:app_flutter/models/product_model.dart';
import 'package:app_flutter/screens/product/product_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_flutter/screens/product/search_Screen.dart';
import 'package:app_flutter/config/update_data.dart';

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
    HomePageContent(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBarTitles[_selectedIndex],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 20, 49),
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

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
            tooltip: 'Menu',
          ),
        ],
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

class HomePageContent extends StatelessWidget {
  final authServices = AuthServices();
  final productServices = ProductServices();
  final userId = FirebaseAuth.instance.currentUser!;
  HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productServices.getProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!;

        final Map<String, List<Product>> groupProducts = {};
        for (var product in products) {
          if (!groupProducts.containsKey(product.style)) {
            groupProducts[product.style] = [];
          }
          groupProducts[product.style]!.add(product);
        }

        final intStyles = groupProducts.keys.toList();
        return ListView.builder(
          itemCount: intStyles.length,
          itemBuilder: (context, index) {
            final type = intStyles[index];
            final productsOfStyle = groupProducts[type]!;
            final firstStyleProducts = productsOfStyle.first;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  ProductCard(product: firstStyleProducts),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
