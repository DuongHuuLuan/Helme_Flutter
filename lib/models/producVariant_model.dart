class ProducvariantModel {
  final String id;
  final String productId;
  final String size;
  final String color;
  final int stock;

  ProducvariantModel({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    required this.stock,
  });

  // lấy dữ liệu từ firestore
  factory ProducvariantModel.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return ProducvariantModel(
      id: documentId,
      productId: data['productId'] ?? '',
      size: data['size'] ?? '',
      color: data['color'] ?? '',
      stock: data['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'size': size,
      'color': color,
      'stock': stock,
    };
  }
}
