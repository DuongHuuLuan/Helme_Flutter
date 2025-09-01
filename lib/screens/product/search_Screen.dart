import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Nhập tên sản phẩm tìm kiếm'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('name_lower', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name_lower', isLessThan: query.toLowerCase() + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Đã xảy ra lỗi!'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Không tìm thấy sản phẩm nào.'));
        }
        var products = snapshot.data!.docs;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: p['imageUrl'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(p['name']),
              subtitle: Text('${p['price']} Đ'),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Gợi ý tìm kiếm'));
  }
}
