import 'package:app_flutter/models/product_model.dart';
import 'package:app_flutter/services/auth_services.dart';
import 'package:app_flutter/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/screens/product/product_card.dart';

class HomeContent extends StatelessWidget {
  final authServices = AuthServices();
  final productServices = ProductServices();
  final userId = FirebaseAuth.instance.currentUser!;
  HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productServices.getProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!;

        final Map<String, List<Product>> groupProduct = {};
        for (var product in products) {
          if (!groupProduct.containsKey(product.style)) {
            groupProduct[product.style] = [];
          }
          groupProduct[product.style]!.add(product);
        }

        final intStyles = groupProduct.keys.toList();
        return ListView.builder(
          itemCount: intStyles.length,
          itemBuilder: (context, index) {
            final type = intStyles[index];
            final productOfStyle = groupProduct[type]!;
            final firstStyleProduct = productOfStyle.first;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  ProductCard(product: firstStyleProduct),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
