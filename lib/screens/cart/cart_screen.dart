import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/services/cart_services.dart';
import 'package:app_flutter/services/order_services.dart';

class CartScreen extends StatelessWidget {
  final cartServices = CartServices();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final orderServices = OrderServices();
  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('ID người dùng $userId');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Giỏ hàng",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: cartServices.getCart(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final cartItems = snapshot.data!;
          print('Snapshot has data. Number of items: ${cartItems.length}');
          print('Data: $cartItems');

          if (cartItems.isEmpty) {
            return const Center(child: Text('Giỏ hàng trống'));
          }
          final total = cartItems.fold<double>(0, (sum, item) {
            return sum + (item['price'] * item['quantity']);
          });
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      child: ListTile(
                        leading:
                            item['imageUrl'] != null &&
                                item['imageUrl'].isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: item['imageUrl'],
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.add_shopping_cart),
                        title: Text(item['name']),
                        subtitle: Text(
                          '${item['price']} VND x ${item['quantity']}',
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            cartServices.deleteFormCart(userId, item['id']);
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: cartItems.length,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Text('Tổng tiền: ${total} VNĐ'),

                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await orderServices.createOrder(
                            userId,
                            cartItems,
                            total,
                          );
                          await cartServices.clearCart(userId);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Thanh toán thành công'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                        }
                      },
                      child: const Text('Xác nhận thanh toán'),
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
