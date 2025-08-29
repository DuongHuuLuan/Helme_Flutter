import 'package:app_flutter/screens/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/services/product_services.dart';
import 'package:app_flutter/models/product_model.dart';
import '../cart/cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  final productServices = ProductServices();
  ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Danh sách sản phẩm'),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (_) => CartScreen()),
      //         );
      //       },
      //       icon: const Icon(Icons.shopping_cart),
      //     ),
      //   ],
      // ),
      body: StreamBuilder<List<Product>>(
        stream: productServices.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // kiểm tra xem nếu không có dữ liệu hoặc danh sách rỗng thì hiển thị chưa có sản phẩm
            return const Center(child: Text('Chưa có sản phẩm'));
          }
          final products =
              snapshot.data!; // nếu đã có dữ liệu thì gán vào biến products

          return ListView.separated(
            itemBuilder: (context, index) {
              final p = products[index]; // đối tượng p tại ví trí index
              return Card(
                child: ListTile(
                  leading: p.imageUrl.isNotEmpty
                      ? Image.network(p.imageUrl, width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.shopping_bag),
                  title: Text(p.name),
                  subtitle: Text('${p.price} VNĐ'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: p),
                      ),
                    );
                  }, // điều hướng đến chi tiết sản phẩm
                ),
              );
            },

            separatorBuilder: (context, index) => const Divider(),
            itemCount: products.length,
          );
        },
      ),
    );
  }
}
