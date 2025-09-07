import 'package:app_flutter/screens/product/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/services/product_services.dart';
import 'package:app_flutter/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final productServices = ProductServices();
  String? selectedStyle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Product>>(
        stream: productServices.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có sản phẩm'));
          }
          final products = snapshot.data!;
          final Map<String, List<Product>> groupProducts = {};
          for (var product in products) {
            if (!groupProducts.containsKey(product.style)) {
              groupProducts[product.style] = [];
            }
            groupProducts[product.style]!.add(product);
          }

          final intStyleProduct = groupProducts.keys.toList();

          final filteredProducts = selectedStyle == null
              ? products
              : groupProducts[selectedStyle] ?? [];
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'DANH MỤC SẢN PHẨM',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Grid danh mục
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: intStyleProduct.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final style = intStyleProduct[index];
                  final productOfStyle = groupProducts[style]!;
                  final title = style.toUpperCase().replaceAll('_', ' ');
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedStyle == style) {
                          selectedStyle == null;
                        } else {
                          selectedStyle = style;
                        }
                      });
                    },
                    child: Card(
                      color: selectedStyle == style
                          ? Colors.amber.shade100
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MŨ BẢO HIỂM $title',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${productOfStyle.length} sản phẩm',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              ...intStyleProduct
                  .where((style) {
                    if (selectedStyle != null) {
                      return style == selectedStyle;
                    }
                    return true;
                  })
                  .map((style) {
                    final productOfStyle = groupProducts[style]!;
                    final title = style.toUpperCase().replaceAll('_', ' ');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Text(
                            'MŨ BẢO HIỂM $title',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productOfStyle.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            final product = productOfStyle[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetailScreen(
                                        product: product,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: CachedNetworkImage(
                                            // width: 100,
                                            // height: 100,
                                            imageUrl: product.imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                            errorWidget: (context, url, error) {
                                              return Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          product.name.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${product.price}Đ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ProductDetailScreen(
                                                  product: product,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            // horizontal: 16,
                                            vertical: 12,
                                          ),
                                          backgroundColor: const Color(
                                            0xFFC7955F,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'CHI TIẾT SẢN PHẨM',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
            ],
          );
        },
      ),
    );
  }
}
