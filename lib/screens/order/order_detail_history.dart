import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_history_screen.dart';

class OrderDetailHistoryScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  OrderDetailHistoryScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = List<Map<String, dynamic>>.from(order['items']);
    final total = order['total'];
    final createdAt = (order['createdAt'] as Timestamp?)?.toDate();

    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết đơn hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ngày đặt: ${createdAt ?? 'N/A'} '),
            Text('Tổng Tiền: $total VNĐ'),
            const SizedBox(height: 15),
            Text('Danh sách sản phẩm:'),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text(
                      'Giá: ${item['pỉce']} VNĐ x ${item['quantity']}',
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
