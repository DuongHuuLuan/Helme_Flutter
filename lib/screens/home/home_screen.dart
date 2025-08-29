import 'package:app_flutter/screens/product/product_list_screen.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authServices = AuthServices();
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
        backgroundColor: Colors.blueAccent,
        actions: [
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
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'Tài khoản',
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
  final userId = FirebaseAuth.instance.currentUser!;
  HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: authServices.getUserProfile(userId.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final appUser = snapshot.data!;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Xin chào ${appUser.name}'),
            ),
            const SizedBox(height: 10),
            Expanded(child: ProductListScreen()),
          ],
        );
      },
    );
  }
}
