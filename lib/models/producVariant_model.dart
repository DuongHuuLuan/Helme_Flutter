class SizeStock {
  final String size;
  final int stock;

  SizeStock({required this.size, required this.stock});

  factory SizeStock.fromMap(Map<String, dynamic> data) {
    return SizeStock(size: data['size'] ?? '', stock: data['stock']);
  }

  Map<String, dynamic> toMap() {
    return {'size': size, 'stock': stock};
  }
}

class ProducvariantModel {
  final String id;
  // final String productId;
  final String imageUrl;
  final List<SizeStock> sizes;
  final String color;

  ProducvariantModel({
    required this.id,
    // required this.productId,
    required this.imageUrl,
    required this.sizes,
    required this.color,
  });

  // lấy dữ liệu từ firestore
  factory ProducvariantModel.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return ProducvariantModel(
      id: documentId,
      // productId: data['productId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      sizes: (data['sizes'] as List<dynamic>? ?? [])
          .map((e) => SizeStock.fromMap(e as Map<String, dynamic>))
          .toList(),
      color: data['color'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'productId': productId,
      'imageUrl': imageUrl,
      'sizes': sizes.map((e) => e.toMap()).toList(),
      'color': color,
    };
  }
}
