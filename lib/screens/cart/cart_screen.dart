import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/services/cart_services.dart';
import 'package:app_flutter/services/order_services.dart';
import 'cart_detail_screen.dart';
import 'package:app_flutter/core/widgets/app_bar.dart';
import 'cart_item.dart';
import 'package:app_flutter/screens/payment/payment_confirm.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartServices = CartServices();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final orderServices = OrderServices();

  final Set<String> _selectedItems = {};
  bool _selectAll = false;

  void _onItemToggled(String itemId, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        _selectedItems.add(itemId);
      } else {
        _selectedItems.remove(itemId);
      }
      _selectAll = _selectedItems.length == cartServices.getCart(userId).length;
    });
  }

  void _onSelectAllToggled(
    bool? isSelected,
    List<Map<String, dynamic>> cartItems,
  ) {
    setState(() {
      _selectAll = isSelected!;
      if (_selectAll) {
        _selectedItems.clear();
        for (var item in cartItems) {
          _selectedItems.add(item['id']);
        }
      } else {
        _selectedItems.clear();
      }
    });
  }

  void _onPayment(List<Map<String, dynamic>> cartItems) async {
    final selectedProducts = cartItems
        .where((item) => _selectedItems.contains(item['id']))
        .toList();
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất 1 sản phẩm để thanh toán'),
        ),
      );
      return;
    }

    final total = selectedProducts.fold<double>(0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });

    try {
      await orderServices.createOrder(userId, selectedProducts, total);
      for (var item in selectedProducts) {
        await cartServices.deleteFormCart(userId, item['id']);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('Thanh toán thành công sản phẩm được chọn'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thanh toán'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ID người dùng $userId');
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Giỏ hàng',
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: cartServices.getCart(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final cartItems = snapshot.data!;

          final _selectedProducts = cartItems
              .where((item) => _selectedItems.contains(item['id']))
              .toList();
          print('Snapshot has data. Number of items: ${cartItems.length}');
          print('Data: $cartItems');

          if (cartItems.isEmpty) {
            return const Center(child: Text('Giỏ hàng trống'));
          }
          final total = cartItems
              .where((element) => _selectedItems.contains(element['id']))
              .fold<double>(0, (sum, item) {
                return sum + (item['price'] * item['quantity']);
              });
          // }
          // );
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final isSelected = _selectedItems.contains(item['id']);
                    return CartItem(
                      item: item,
                      userId: userId,
                      isSelected: isSelected,
                      cartServices: cartServices,
                      onChanged: (bool? value) {
                        return _onItemToggled(item['id'], value);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: cartItems.length,
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Tổng tiền: ${total}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // _onPayment(cartItems);
                        if (_selectedProducts.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PaymentConfirm(
                                  items: _selectedProducts,
                                  total: total,
                                );
                              },
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.payment, color: Colors.white),
                      label: Text(
                        'Thanh toán ${_selectedItems.length} Sản phẩm',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 1, 20, 49),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
