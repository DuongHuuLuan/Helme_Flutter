import 'package:app_flutter/models/order_model.dart';
import 'package:app_flutter/models/product_model.dart';
import 'package:app_flutter/screens/product/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      body: StreamBuilder<List<OrderModel>>(
        stream: orderServices.getUserOrders(userId),
        builder: (context, snapshot) {
          // print('Dữ liệu: ${snapshot.data}');
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          // print('Order : $orders');
          if (orders.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào'));
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              final order = orders[index];
              // final createdAt = (order['createdAt'] as Timestamp?)?.toDate();
              // final items = List<Map<String, dynamic>>.from(order['items']);
              // final total = order['total'];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return OrderDetailHistoryScreen(order: order.toMap());
                      },
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...order.items.map((item) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl: item['imageUrl'] ?? '',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? 'Tên sản phẩm',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Text(
                                    //   item['style'],
                                    //   style: TextStyle(color: Colors.grey),
                                    // ),
                                    Text(
                                      '${item['price']} Đ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text(
                                        //   '${item['price']} Đ',
                                        //   style: TextStyle(
                                        //     fontSize: 14,
                                        //     color: Colors.black87,
                                        //   ),
                                        // ),
                                        Text(
                                          'Tổng số tiền (${item['quantity']} sản phẩm): ${item['price'] * (item['quantity'] ?? 1)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // trạng thái đơn hàng
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Trạng thái: ${order.paymentStatus}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (order.paymentStatus ==
                                            'Đã thanh toán')
                                          ElevatedButton(
                                            onPressed: () {
                                              final product = Product(
                                                id: item['id'],
                                                name: item['name'],
                                                description:
                                                    item['description'],
                                                price: (item['price'])
                                                    .toDouble(),
                                                style: item['style'],
                                                imageUrl: item['imageUrl'],
                                                name_lower:
                                                    item['name_lower'] ?? '',
                                                sizes: item['sizes'] is List
                                                    ? List<String>.from(
                                                        item['sizes'],
                                                      )
                                                    : [item['sizes'] ?? ''],
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ProductDetailScreen(
                                                      product: product,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Mua lại',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  // child: ListTile(
                  //   title: Text('Tổng tiền: ${order.total} Đ'),
                  //   subtitle: Text(
                  //     'Ngày: ${order.createdAt != null ? order.createdAt.toString() : 'N/A'}\n'
                  //     'Sản phẩm: ${order.items.length}',
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             OrderDetailHistoryScreen(order: order.toMap()),
                  //       ),
                  //     );
                  //   },
                  // ),
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
