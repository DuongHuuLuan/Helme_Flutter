import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/services/order_services.dart';
import 'order_detail_history.dart';

class OrderHistoryScreen extends StatelessWidget {
  final orderServices = OrderServices();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    print('Id Người dùng: $userId');
    return Scaffold(
      // appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderServices.getUserOrders(userId),
        builder: (context, snapshot) {
          print('Dữ liệu: ${snapshot.data}');
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!.docs;
          print('Order : $orders');
          if (orders.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào'));
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final createdAt = (order['createdAt'] as Timestamp?)?.toDate();
              final items = List<Map<String, dynamic>>.from(order['items']);
              final total = order['total'];

              return Card(
                child: ListTile(
                  title: Text('Tổng tiền: $total VNĐ'),
                  subtitle: Text(
                    'Ngày: ${createdAt != null ? createdAt.toString() : 'N/A'}\n'
                    'Sản phẩm: ${items.length}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetailHistoryScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: orders.length,
          );
        },
      ),
    );
  }
}
