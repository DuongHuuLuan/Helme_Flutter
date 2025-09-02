import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  final orderRef = FirebaseFirestore.instance.collection('orders');

  // tạo đơn hàng mới thêm lên firestore
  Future<void> createOrder(
    String userId,
    List<Map<String, dynamic>> items,
    double total, {
    Map<String, dynamic>? customerInfo,
  }) async {
    await orderRef.add({
      'userId': userId,
      'items': items,
      'total': total,
      'createdAt':
          FieldValue.serverTimestamp(), // dùng để quản lý thời gian tạo đơn hàng
      if (customerInfo != null) 'customerInfo': customerInfo,
    });
  }

  // lấy đơn hàng từ firestore
  Stream<QuerySnapshot> getUserOrders(String userId) {
    return orderRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
