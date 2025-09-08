class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String style;
  final String imageUrl;
  final String name_lower;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.style,
    required this.imageUrl,
    required this.name_lower,
  });

  // chinh sua du lieu lay tu firestore
  factory Product.formMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      name_lower: data['name_lower'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      style: data['style'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // gui du lieu product len firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'name_lower': name_lower,
      'description': description,
      'price': price,
      'style': style,
      'imageUrl': imageUrl,
    };
  }
}
