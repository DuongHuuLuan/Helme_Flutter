// cần lưu ý set quyền quản trị cho file này để tránh người dùng chạy nhầm
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updatedProductNamesToLowerCase() async {
  final productsRef = FirebaseFirestore.instance.collection('products');

  final productsSnapshot = await productsRef.get();

  for (final doc in productsSnapshot.docs) {
    final data = doc.data();
    final String originalName = data['name'];

    final String lowerCaseName = originalName.toLowerCase();

    await doc.reference.update({'name_lower': lowerCaseName});
    print('Hoàn thành cập nhật tất cả tài liệu.');
  }
}
