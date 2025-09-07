import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double total;
  final double shippingFree;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime? createdAt;
  final Map<String, dynamic>? customerInfo;
  final String notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.shippingFree,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.customerInfo,
    this.notes = '',
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document ${doc.id} chưa có dữ liệu');
    }
    return OrderModel(
      id: doc.id,
      userId: data['userId'],
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      total: (data['total'] ?? 0).toDouble(),
      shippingFree: (data['shippingFree'] ?? 0).toDouble(),
      status: data['status'] ?? 'Chưa xác định',
      paymentMethod: data['paymentMethod'] ?? 'COD',
      paymentStatus: data['paymentStatus'] ?? 'Chưa xác định',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      customerInfo: data['customerInfo'],
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items,
      'total': total,
      'shippingFree': shippingFree,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt,
      'customerInfo': customerInfo,
      'notes': notes,
    };
  }
}
