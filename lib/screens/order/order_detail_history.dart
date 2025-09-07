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
    final createdAt = (order['createdAt'] is Timestamp
        ? (order['createdAt'] as Timestamp).toDate()
        : order['createdAt'] as DateTime?);
    final orderId = order['id'] ?? 'N/A';
    final status = order['status'] ?? 'Chưa xác định';
    final custommerInfo = order['customerInfo'] ?? {};
    final shipping = order['shipping'] ?? 0;
    final paymentMethod = order['paymentMethod'] ?? 'COD';
    final paymentStatus = order['paymentStatus'] ?? 'Chưa rõ';
    final notes = order['notes'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết đơn hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // thông tin đơnhàng
            Text(
              'Mã đơn hàng: $orderId',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Ngày đặt: ${createdAt ?? 'N/A'} '),
            // Text('Tổng Tiền: $total Đ'),
            Text('Trạng thái: $status'),
            // thông tin khách hàng
            const SizedBox(height: 10),
            const Text(
              'Thông tin khách hàng:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Tên: ${custommerInfo['name'] ?? 'N/A'}'),
            Text('SĐt: ${custommerInfo['phone'] ?? 'N/A'}'),
            Text('Email: ${custommerInfo['email'] ?? 'N/A'}'),
            Text('Địa chỉ: ${custommerInfo['address'] ?? 'N/A'}'),
            const SizedBox(height: 15),
            Text(
              'Danh sách sản phẩm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text(
                      'Giá: ${item['price']} VNĐ x ${item['quantity']}',
                    ),
                    trailing: Text(
                      'Tổng: $total Đ',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: items.length,
              ),
            ),
            const SizedBox(height: 10),
            Text('Phương thức thanh toán: $paymentMethod'),
            Text('Trạng thái: $paymentStatus'),
            Text('Ghi chú: ${custommerInfo['notes']}'),
            const Divider(),
            Text(
              'Tổng cộng: ${total + shipping} Đ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
