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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: intStyles.length,
                itemBuilder: (context, index) {
                  final type = intStyles[index];
                  final productOfStyle = groupProduct[type]!;
                  final firstStyleProduct = productOfStyle.first;
                  return Column(
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
                  );
                },
              ),
              Container(
                color: Color.fromARGB(255, 0, 0, 0),
                child: Column(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: intStyles.length,
                        itemBuilder: (context, index) {
                          // final product = products[index];
                          final type = intStyles[index];
                          final productOfStyle = groupProduct[type]!;
                          final firstProductStyle = productOfStyle.first;
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: ProductAllStyleCard(
                              product: firstProductStyle,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...intStyles.map((style) {
                      final productOfStyle = groupProduct[style]!;
                      final title = style.toUpperCase().replaceAll('_', '');
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'MŨ BẢO HIỂM ${title}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 350,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productOfStyle.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    child: ProductStyleCard(
                                      product: productOfStyle[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 5),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         'MŨ BẢO HIỂM ${title}',
                      //         style: const TextStyle(
                      //           fontSize: 22,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 10),
                      //       SizedBox(
                      //         height: 350,
                      //         child: ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: productOfStyle.length,
                      //           itemBuilder: (context, index) {
                      //             return Padding(
                      //               padding: EdgeInsets.only(
                      //                 left: 16,
                      //                 right: index == productOfStyle.length - 1
                      //                     ? 16
                      //                     : 0,
                      //               ),
                      //               child: ProductStyleCard(
                      //                 product: productOfStyle[index],
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
