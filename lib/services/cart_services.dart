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
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'quantity': 1,
      });
    }
  }

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
