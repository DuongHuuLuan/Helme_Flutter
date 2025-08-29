import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_flutter/models/product_model.dart';

class ProductServices {
  final _db = FirebaseFirestore.instance;

  // lay danh sach san pham

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.formMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Thêm sản phẩm (dùng cho admin)
  Future<void> addProduct(Product product) async {
    await _db.collection('products').add(product.toMap());
  }
}
