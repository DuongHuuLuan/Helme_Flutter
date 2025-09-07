import 'package:app_flutter/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  final orderRef = FirebaseFirestore.instance.collection('orders');

  // tạo đơn hàng mới thêm lên firestore
  Future<void> createOrder(
    String userId,
    List<Map<String, dynamic>> items,
    double total, {
    Map<String, dynamic>? customerInfo,
    String paymentMethod = 'Thanh toán khi nhận hàng',
    double shippingFree = 0,
    String notes = '',
  }) async {
    await orderRef.add({
      'userId': userId,
      'items': items,
      'total': total,
      'createdAt':
          FieldValue.serverTimestamp(), // dùng để quản lý thời gian tạo đơn hàng
      'status': 'Chờ xử lý',
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentMethod == 'Thanh toán khi nhận hàng'
          ? 'Chưa thanh toán'
          : 'Đã thanh toán',
      'shippingFree': shippingFree,
      'notes': notes,
      if (customerInfo != null) 'customerInfo': customerInfo,
    });
  }

  // lấy đơn hàng từ firestore
  // Stream<OrderModel> getUserOrders(String userId) {
  //   return orderRef
  //       .where('userId', isEqualTo: userId)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //         return snapshot.docs.map((doc) {
  //           return OrderModel.fromFirestore(doc;)
  //         }).toList();
  //       });
  // }
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return orderRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                try {
                  return OrderModel.fromFirestore(doc);
                } catch (e) {
                  print("Lỗi parse OrderModel: $e");
                  return null;
                }
              })
              .whereType<OrderModel>()
              .toList(); // bỏ các null
        });
  }
}
