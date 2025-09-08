import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_flutter/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  final _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance;
  // thêm vào giỏ hàng
  Future<void> addToCart(String uid, Product product) async {
    final cartRef = _db.collection('users').doc(uid).collection('cart');
    final existing = await cartRef.doc(product.id).get();

    if (existing.exists) {
      await cartRef.doc(product.id).update({
        'quantity': FieldValue.increment(1),
      });
    } else {
      await cartRef.doc(product.id).set({
        'name': product.name,
        'style': product.style,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'quantity': 1,
      });
    }
  }

  // Future<void> addToCart(
  //   String userId,
  //   Product product, {
  //   required String variantId,
  //   required String color,
  //   required String size,
  //   required String imageUrl,
  // }) async {
  //   final cartRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('cart')
  //       .doc(variantId); //mỗi variantId là duy nhất trong giỏ hàng

  //   await cartRef.set({
  //     'productId': product.id,
  //     'name': product.name,
  //     'price': product.price,
  //     'color': color,
  //     'size': size,
  //     'imageUrl': imageUrl,
  //     'quantity': FieldValue.increment(1), //tự động +1 nếu đã tồn tại
  //     'createdAt': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));

  //   print(" thêm $variantId  vào giỏ hàng của $userId");
  // }

  // lấy sản phẩm từ giỏ hàng
  Stream<List<Map<String, dynamic>>> getCart(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final itemData = <String, dynamic>{};

            itemData['id'] = doc.id;

            final data = doc.data();
            itemData['name'] = data['name'];
            itemData['style'] = data['style'];
            itemData['price'] = data['price'];
            itemData['quantity'] = data['quantity'];
            itemData['imageUrl'] = data['imageUrl'];
            itemData['description'] = data['description'];
            return itemData;
          }).toList(),
        );
  }

  // xóa sản phẩm trong giỏ
  Future<void> deleteFormCart(String userId, String productId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  // lấy đơn hàng theo id từ giỏ hàng
  Future<Map<String, dynamic>?> getItemProductCart(
    String productId,
    String userId,
  ) async {
    final data = await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .get();
    return data.data();
  }

  // cập nhật số lượng sản phẩn
  Future<Map<String, dynamic>?> updatedQuantityProduct(
    String productId,
    String userId,
    int newQuantity,
  ) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .update({'quantity': newQuantity});
  }

  // xóa tất cả sản phẩm trong giỏ
  Future<void> clearCart(String userId) async {
    final cartSnapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();

    for (final doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
